local isSelling = false
local usedNPCS = {}
local robbers = {}
local alreadySelling = false
local targetDrugs = {}
local ignoredPeds = {}


function startTarget(entity, options)
    if not next(options) then return end
    if lib.table.contains(ignoredPeds, entity) then
        return
    end
    if lib.table.contains(freezy.ignoredPeds, GetEntityModel(entity)) then
        return
    end
    if not IsEntityAPed(entity) then
        return
    end

    exports.ox_target:addLocalEntity(entity, options)
    for _, option in pairs(options) do
        targetDrugs[option.name] = true
    end

end

function stopTarget(entity)
    local oxTargetOptionNames = {}
    for optionName, _ in pairs(targetDrugs) do
        table.insert(oxTargetOptionNames, optionName)
    end
    if not next(oxTargetOptionNames) then return end
    exports.ox_target:removeLocalEntity(entity, oxTargetOptionNames)
end

function AllNpcs() -- Returns (hopefully) all npcs
    local playerPeds = {}
    local pedList = GetGamePool('CPed')
    local peds = {}
    for _, activePlayer in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(activePlayer)
        playerPeds[#playerPeds + 1] = ped
    end
    for i = 1, #pedList, 1 do
        local found = false
        for p = 1, #playerPeds, 1 do
            if playerPeds[p] == pedList[i] then
                found = true
            end
        end
        if not found then
            peds[#peds + 1] = pedList[i]
        end
    end
    return peds
end

function canSellDrugs() -- Checks if player can sell drugs
    local drugsforsale = {}
    local drugNames = {}
    local canSell = false
    for drug, _ in pairs(freezy.Sell) do
        table.insert(drugNames, drug)
    end
    drugsforsale = lib.callback.await('freezy_drugselling:getPlayerDrugs', false, drugNames)
    while not drugsforsale do
        drugsforsale = lib.callback.await('freezy_drugselling:getPlayerDrugs', false, drugNames)
    end
    for _, drugsCount in pairs(drugsforsale) do
        if drugsCount ~= 0 then
            canSell = true
        end
    end
    return freezy.sellingOnByDefault and true or canSell, drugsforsale
end

function takeBackDrugs(theEntity, drugCount, drugName, drugLabel)
    lib.notify({
        title = Locale[freezy.Locale].NotifyTitle,
        description = Locale[freezy.Locale].GotBack:format(drugCount,drugLabel),
    })
    DebugPrint('Took back '..drugCount..'x of '..drugLabel)
    TriggerServerEvent('freezy_drugselling:retrieve', drugName, drugCount)
    stopTarget(theEntity)
    robbers[theEntity] = nil
    table.insert(usedNPCS, theEntity)
end

function successfulSell(entity, drugName, drugCount)
    stopTarget(entity)
    table.insert(usedNPCS, entity)
    ClearPedTasks(entity)
    TaskTurnPedToFaceEntity(entity, PlayerPedId(), -1)
    TaskLookAtEntity(entity, PlayerPedId(), -1, 2048, 3)
    Wait(1000)
    ClearPedTasks(entity)
    FreezeEntityPosition(entity, true)
    TaskStartScenarioInPlace(entity, freezy.npcAnimation, 0, false)
    lib.progressCircle({
        duration = math.random(5000,8000),
        label = Locale[freezy.Locale].Offering,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
		anim = {
			dict = 'misscarsteal4@actor',
			clip = 'actor_berating_loop'
		},
    })
    local success = lib.callback.await('freezy_drugselling:giveDrugs', false, drugName, drugCount)
    if not success then
        TriggerServerEvent('freezy_drugselling:cheetah')
        DropPlayer(source,Locale[freezy.Locale].Cheater)
    else
        ClearPedTasks(PlayerPedId())
        local drugLabel = freezy.Sell[drugName].label
        DebugPrint('Sold '..drugCount..'x of '..drugLabel)
        lib.notify({
            title = Locale[freezy.Locale].NotifyTitle,
            description = Locale[freezy.Locale].Sold:format(drugCount,drugLabel),
        })
        ClearPedTasks(entity)
        TriggerServerEvent('freezy_drugselling:pay', drugName, drugCount)
    end
    SetPedKeepTask(entity, false)
    SetEntityAsNoLongerNeeded(entity)
    ClearPedTasks(entity)
    FreezeEntityPosition(entity, false)
end

function robPlayer(entity, drugName, drugCount)
    ClearPedTasks(entity)
    TaskTurnPedToFaceEntity(entity, PlayerPedId(), -1)
    TaskLookAtEntity(entity, PlayerPedId(), -1, 2048, 3)
    Wait(1000)
    ClearPedTasks(entity)
    Wait(1000)
    FreezeEntityPosition(entity, true)
    TaskStartScenarioInPlace(entity, freezy.npcAnimation, 0, false)
    lib.progressCircle({
        duration = math.random(5000,8000),
        label = Locale[freezy.Locale].Offering,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
		anim = {
			dict = 'misscarsteal4@actor',
			clip = 'actor_berating_loop'
		},
    })
    stopTarget(entity)
    ClearPedTasks(entity)
    local success = lib.callback.await('freezy_drugselling:giveDrugs', false, drugName, drugCount)
    Wait(200)
    local drugLabel = freezy.Sell[drugName].label
    if not success then
        TriggerServerEvent('freezy_drugselling:cheetah')
        DropPlayer(source,Locale[freezy.Locale].Cheater)
    else
        if freezy.ragdollOnSteal then
            DebugPrint('Set ragdoll on player')
            SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
        end
        stopTarget(entity)
        lib.notify({
            title = Locale[freezy.Locale].NotifyTitle,
            description = Locale[freezy.Locale].Robbed,
        })
        stopTarget(entity)
        table.insert(robbers, entity)
        startTarget(entity, {{
                canInteract = function(_, distance, _)
                    return distance <= 4.0
                end,
                onSelect = function(data)
                    takeBackDrugs(data.entity, drugCount, drugName, drugLabel)
                end,
                label = Locale[freezy.Locale].Retrieve,
                icon = 'fa-solid fa-hand-holding-dollar',
                name = "take_back_drugs",
                distance = freezy.interactDistance
            }}
        )
    end
    ClearPedTasksImmediately(entity)
    TaskSmartFleeCoord(entity, GetEntityCoords(PlayerPedId()), 999.9, math.random(30000,120000), true, true)
    SetEntityMaxSpeed(entity,freezy.npcStealMaxSpeed)
    DebugPrint('NPC is running away')
    FreezeEntityPosition(entity, false)
    DebugPrint('Unfroze NPC position')
end

function setEntityAggressive(entity)
    table.insert(usedNPCS, entity)
    ClearPedTasks(entity)
    TaskTurnPedToFaceEntity(entity, PlayerPedId(), -1)
    TaskLookAtEntity(entity, PlayerPedId(), -1, 2048, 3)
    Wait(1000)
    ClearPedTasks(entity)
    Wait(1900)
    lib.notify({
        title = Locale[freezy.Locale].NotifyTitle,
        description = Locale[freezy.Locale].Angry,
    })
    DebugPrint('NPC began agressive')
    if freezy.npcAgressivityLevel == 1 then
    SetPedCombatAttributes(entity, 5, true)
    SetPedCombatAttributes(entity, 46, true)
    TaskCombatPed(entity,PlayerPedId(),0,16)
    DebugPrint('Attacking player - Agressivity level 1')
    elseif freezy.npcAgressivityLevel == 2 then
        GiveWeaponToPed(entity,freezy.allowedNPCWeapons[ math.random( #freezy.allowedNPCWeapons ) ],30,false,false)
        SetPedCombatAttributes(entity, 0, true)
        SetPedCombatAttributes(entity, 5, true)
        SetPedCombatAttributes(entity, 46, true)
        SetPedCombatAbility(entity,1)
        TaskCombatPed(entity,PlayerPedId(),0,16)
        DebugPrint('Attacking player - Agressivity level 2')
    end
end

function notInterested(entity)
    table.insert(usedNPCS, entity)
    table.insert(usedNPCS, entity)
    ClearPedTasks(entity)
    TaskTurnPedToFaceEntity(entity, PlayerPedId(), -1)
    TaskLookAtEntity(entity, PlayerPedId(), -1, 2048, 3)
    Wait(2000)
    lib.notify({
        title = Locale[freezy.Locale].NotifyTitle,
        description = Locale[freezy.Locale].NotInterested,
        icon='ban',
    })
    TaskPlayAnim(entity, "gestures@f@standing@casual", "gesture_shrug_hard", 2.0, 2.0, 1000, 16, 0, 0, 0)
    DebugPrint('NPC refused')
    ClearPedTasks(entity)
end

function tryToSell(entity, drugName, drugCount)
    if alreadySelling then
        lib.notify({
            title = Locale[freezy.Locale].NotifyTitle,
            description = Locale[freezy.Locale].AlreadySelling,
            icon='warning',
        })
        return
    end
    alreadySelling = true
    if math.random(1, 100) > freezy.Sell[drugName].successChance then
        if math.random(1, 100) < freezy.Sell[drugName].attackChance then
            setEntityAggressive(entity)
        else
            notInterested(entity)
        end
    else
        local sellAmount = math.random(drugCount >= freezy.Sell[drugName].sellRange[1] and freezy.Sell[drugName].sellRange[1] or drugCount, drugCount >= freezy.Sell[drugName].sellRange[2] and freezy.Sell[drugName].sellRange[2] or drugCount)
        if math.random(1, 100) < freezy.Sell[drugName].stealChance then
            robPlayer(entity, drugName, sellAmount)
        else
            successfulSell(entity, drugName, sellAmount)
        end
        if freezy.Sell[drugName].policeChance >= math.random(1, 100) then
            Dispatch()
        end
    end
    alreadySelling = false
end

function sell()
    CreateThread(function ()
        while true do
            local buyers = AllNpcs()
            for _, npcBuyer in pairs(buyers) do
                if not lib.table.contains(robbers, npcBuyer) then
                    stopTarget(npcBuyer)
                end
            end
            local canSell, drugsforsale = canSellDrugs()
            if not canSell then
                isSelling = false
            end
            local sellOptions = {}
            for drugName, drugCount in pairs(drugsforsale) do
                if drugCount >= 1 then
                    local drugLabel = freezy.Sell[drugName].label
                    table.insert(sellOptions, {
                        canInteract = function(interactEntity, distance, _)
                            if IsEntityDead(interactEntity) then
                                return false
                            end
                            if distance >= 4.0 then
                                return false
                            end
                            return true
                        end,
                        action = function(entity)
                            tryToSell(entity, drugName, drugCount)
                        end,
                        onSelect = function(data)
                            tryToSell(data.entity, drugName, drugCount)
                        end,
                        label = Locale[freezy.Locale].OfferDrugs:format(drugLabel),
                        icon = 'fa-solid fa-cannabis',
                        name = "sell_option_" .. drugName,
                    })
                end
            end
            for _, npcBuyer in pairs(buyers) do
                if not lib.table.contains(usedNPCS, npcBuyer) then
                    startTarget(npcBuyer, sellOptions)
                end
            end
            Wait(5000)
        end
    end)
end
function sellMode()
    local buyers = AllNpcs()
    for _, npcBuyer in pairs(buyers) do
        stopTarget(npcBuyer)
    end
    local canSell, _ = canSellDrugs()
    if not canSell then
        isSelling = false
        lib.notify({
            title = Locale[freezy.Locale].NotifyTitle,
            description=Locale[freezy.Locale].NoDrugs,
            icon='warning',
        })
        return
    end
    isSelling = not isSelling
    if isSelling then
        if not freezy.sellingOnByDefault then
            lib.notify({
                title = Locale[freezy.Locale].NotifyTitle,
                description = Locale[freezy.Locale].ManualSellingEnabled,
                duration = 5000,
                icon = 'cannabis',
            })

        end
        sell()
    else
        lib.notify({
            title = Locale[freezy.Locale].NotifyTitle,
            description = Locale[freezy.Locale].ManualSellingDisabled,
            duration = 2000,
            icon = 'cannabis',
        })
    end
end
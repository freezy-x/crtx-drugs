local stopped = false
local hasEffect = false

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        DebugPrint("Animation "..dict.." isn't loaded, retrying in 500ms")
        Citizen.Wait(500)
    end
end

-- Opium
exports('opium', function(data, slot)
    exports.ox_inventory:useItem(data, function(data)
        if data then
            hasEffect = true
            TriggerEvent('freezy_drugs:opiumEffect')
        end
    end)
end)

-- Cocaine
exports('cocaine', function(data, slot)
    
    exports.ox_inventory:useItem(data, function(data)
        if data then
            hasEffect = true
            TriggerEvent('freezy_drugs:cocaineEffect')
        end
    end)
end)

exports('pure_meth', function(data, slot)
    exports.ox_inventory:useItem(data, function(data)
        if data then
            hasEffect = true
            TriggerEvent('freezy_drugs:pureMethEffect')
        end
    end)
end)

exports('meth', function(data, slot)
    exports.ox_inventory:useItem(data, function(data)
        if data then
            hasEffect = true
            TriggerEvent('freezy_drugs:methEffect')
        end
    end)
end)

exports('weed', function(data, slot)
    exports.ox_inventory:useItem(data, function(data)
        if data then
            hasEffect = true
            TriggerEvent('freezy_drugs:weedEffect')
        end
    end)
end)

-- Stop Effects
exports('stopEffects', function(data, slot)
    exports.ox_inventory:useItem(data, function(data)
        if data then
            ResetPedMovementClipset(PlayerPedId())
            AnimpostfxStopAll()
            if hasEffect then
                lib.notify({description = Locale[freezy.Locale]['EffectsDone']})
                hasEffect = false
            end
        end
    end)
end)

RegisterNetEvent('freezy_drugs:methEffect')
AddEventHandler('freezy_drugs:methEffect',function ()
    loadAnimDict("anim@mp_player_intcelebrationmale@face_palm")
    TaskPlayAnim(PlayerPedId(), "anim@mp_player_intcelebrationmale@face_palm", "face_palm", 3.0, 3.0, 3000, 48, 0, false, false, false)
    Citizen.Wait(2000)
    ShakeGameplayCam("MEDIUM_EXPLOSION_SHAKE", .2)
    SetPedMovementClipset(PlayerPedId(), "move_m@drunk@slightlydrunk", true)
    lib.notify({description = Locale[freezy.Locale]['TookMethBag']})
    AnimpostfxPlay("DrugsDrivingIn", 30000, true)
    Citizen.Wait(1000)
    AnimpostfxPlay("DrugsMichaelAliensFightIn", 100000, true)
    Citizen.Wait(freezy.EffectDurations['Meth'])
    ResetPedMovementClipset(PlayerPedId())
    AnimpostfxStopAll()
    if hasEffect then
        lib.notify({description = Locale[freezy.Locale]['EffectsDone']})
    end
end)

RegisterNetEvent('freezy_drugs:weedEffect')
AddEventHandler('freezy_drugs:weedEffect',function ()
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_SMOKING_POT", 0, 1)
    Citizen.Wait(4500)
    ClearPedTasks(PlayerPedId())
    Citizen.Wait(2000)
    ShakeGameplayCam("MEDIUM_EXPLOSION_SHAKE", .15)
    SetPedMovementClipset(PlayerPedId(), "move_m@drunk@slightlydrunk", true)
    lib.notify({description = Locale[freezy.Locale]['SmokedJoint']})
    AnimpostfxPlay("DrugsDrivingIn", 30000, true)
    Citizen.Wait(1000)
    AnimpostfxPlay("DrugsMichaelAliensFightIn", 100000, true)
    Citizen.Wait(freezy.EffectDurations['Weed'])
    ResetPedMovementClipset(PlayerPedId())
    AnimpostfxStopAll()
    if hasEffect then
        lib.notify({description = Locale[freezy.Locale]['EffectsDone']})
    end
end)

RegisterNetEvent('freezy_drugs:pureMethEffect')
AddEventHandler('freezy_drugs:pureMethEffect',function ()
    loadAnimDict("anim@mp_player_intcelebrationmale@face_palm")
    TaskPlayAnim(PlayerPedId(), "anim@mp_player_intcelebrationmale@face_palm", "face_palm", 3.0, 3.0, 3000, 48, 0, false, false, false)
    Citizen.Wait(2000)
    ShakeGameplayCam("MEDIUM_EXPLOSION_SHAKE", .8)
    RequestAnimSet("MOVE_M@DRUNK@VERYDRUNK")
    while not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") do
        DebugPrint("Attempting to load walk style...")
        Citizen.Wait(0)
    end
    SetPedMovementClipset(PlayerPedId(), "MOVE_M@DRUNK@VERYDRUNK", true)
    lib.notify({description = Locale[freezy.Locale]['TookMeth']})
    AnimpostfxPlay("DrugsDrivingIn", 30000, true)
    Citizen.Wait(1000)
    AnimpostfxStop("DrugsDrivingIn")
    AnimpostfxPlay("DrugsDrivingOut", 20000, true)
    AnimpostfxStop("DrugsMichaelAliensFightIn")
    AnimpostfxPlay("DrugsMichaelAliensFightIn", 100000, true)
    Citizen.Wait(freezy.EffectDurations['Meth'])
    ResetPedMovementClipset(PlayerPedId())
    AnimpostfxStopAll()
    if hasEffect then
        lib.notify({description = Locale[freezy.Locale]['EffectsDone']})
    end
end)

RegisterNetEvent('freezy_drugs:cocaineEffect')
AddEventHandler('freezy_drugs:cocaineEffect',function ()
    loadAnimDict("anim@mp_player_intcelebrationmale@face_palm")
    TaskPlayAnim(PlayerPedId(), "anim@mp_player_intcelebrationmale@face_palm", "face_palm", 3.0, 3.0, 3000, 48, 0, false, false, false)
    Citizen.Wait(2000)
    ShakeGameplayCam("MEDIUM_EXPLOSION_SHAKE", .3)
    SetPedMovementClipset(PlayerPedId(), "move_m@drunk@slightlydrunk", true)
    lib.notify({description = Locale[freezy.Locale]['TookCocaine']})
    AnimpostfxPlay("DrugsDrivingIn", 30000, true)
    Citizen.Wait(1000)
    AnimpostfxPlay("DrugsMichaelAliensFightIn", 100000, true)
    Citizen.Wait(freezy.EffectDurations['Cocaine'])
    ResetPedMovementClipset(PlayerPedId())
    AnimpostfxStopAll()
    if hasEffect then
        lib.notify({description = Locale[freezy.Locale]['EffectsDone']})
    end
end)

RegisterNetEvent('freezy_drugs:opiumEffect')
AddEventHandler('freezy_drugs:opiumEffect',function ()
    loadAnimDict("anim@mp_player_intcelebrationmale@face_palm")
    TaskPlayAnim(PlayerPedId(), "anim@mp_player_intcelebrationmale@face_palm", "face_palm", 3.0, 3.0, 3000, 48, 0, false, false, false)
    RequestAnimSet("move_m@drunk@slightlydrunk")
    while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
        Citizen.Wait(0)
    end
    Citizen.Wait(2000)
    ShakeGameplayCam("MEDIUM_EXPLOSION_SHAKE", .2)
    SetPedMovementClipset(PlayerPedId(), "move_m@drunk@slightlydrunk", true)
    lib.notify({description = Locale[freezy.Locale].SniffedOpium})
    AnimpostfxPlay("DrugsDrivingIn", 30000, true)
    Citizen.Wait(1000)
    AnimpostfxPlay("DrugsMichaelAliensFightIn", 100000, true)
    Citizen.Wait(freezy.EffectDurations['Opium'])
    ResetPedMovementClipset(PlayerPedId())
    AnimpostfxStopAll()
    if not stopped then
        lib.notify({description = Locale[freezy.Locale]['EffectsDone']})
    end
end)
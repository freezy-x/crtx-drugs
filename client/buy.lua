ESX = exports["es_extended"]:getSharedObject()


RegisterNetEvent('openSellersMenu')
AddEventHandler('openSellersMenu', function(items)
    local options = {}

    for index, item in ipairs(freezy['Buy']) do
        table.insert(options, {
            title = item.label .. " - $" .. item.price,
            event = 'buyItemss_' .. index,
            arrow = true
        })
    end

    lib.registerContext({
        id = 'sellmenu',
        title = 'Buying Menu',
        options = options
    })

    lib.showContext('sellmenu')
end)

for index, item in ipairs(freezy['Buy']) do
    RegisterNetEvent('buyItemss_' .. index)
    AddEventHandler('buyItemss_' .. index, function()
        local itemIndex = index
        local input = lib.inputDialog('How many do you want to buy?', {'Enter quantity'})
        if not input then return end
        local count = tonumber(input[1])
        if count > 0 then
            TriggerServerEvent('buyItems_' .. index, count)
        end
    end)
end



local ox_target = exports.ox_target

for k, v in pairs(freezy['Coords'].Buyers) do
    ox_target:addSphereZone({
        name = 'Sellers' ..k,
        coords = v.coords,
        radius = 0.45,
        debug = drawZones,
        options = {
            {
                name = 'satinal',
                event = 'openSellersMenu',
                label = Locale[freezy.Locale].Buy,
                icon = 'fas fa-comments',
                canInteract = function(entity, distance, coords, name)
                    return true
                end
            }
        },
    })
end

Citizen.CreateThread(function()

    for k,v in pairs(freezy['Coords'].Dealers) do
        RequestModel(v.npc.ped)
        while not HasModelLoaded(v.npc.ped) do
            Wait(1)
        end
        stanley = CreatePed(1, v.npc.ped, v.npc.x, v.npc.y, v.npc.z - 1, v.npc.h, false, true)
        SetBlockingOfNonTemporaryEvents(stanley, true)
        SetPedDiesWhenInjured(stanley, false)
        SetPedCanPlayAmbientAnims(stanley, true)
        SetPedCanRagdollFromPlayerImpact(stanley, false)
        SetEntityInvincible(stanley, true)
        FreezeEntityPosition(stanley, true)
        TaskStartScenarioInPlace(stanley, v.npc.anim, 0, true);
        
    end

end)








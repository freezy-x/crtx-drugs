if freezy.EnableDrugs.Opium then

    local spawned = false

    local Opiums = {}


    function SpawnOpium(count)
        for i=0, count-1 do
        local coordsx = freezy.Drugs['Opium Field'].Coords.x+math.random(1,16)
        local coordsy = freezy.Drugs['Opium Field'].Coords.y+math.random(1,16)
        local coordsz = freezy.Drugs['Opium Field'].Coords.z
        Opium = CreateObject('prop_plant_fern_01b', coordsx,coordsy,coordsz,true, true, false)

        table.insert(Opiums,Opium)
        FreezeEntityPosition(Opium,true)
        end
    end
    local options = {
        {
            event = 'freezy_drugs:pickOpium',
            icon = 'fa-solid fa-pills',
            label = Locale[freezy.Locale].PickOpium,
            distance = 2.1
        }
    }
    exports.ox_target:addModel(`prop_plant_fern_01b`, options)

    Citizen.CreateThread(function ()
        Citizen.Wait(1000)
        while true do
            Wait(1000)
            if GetDistanceBetweenCoords(freezy.Drugs['Opium Field'].Coords.x,freezy.Drugs['Opium Field'].Coords.y,freezy.Drugs['Opium Field'].Coords.z,GetEntityCoords(PlayerPedId())) <= freezy.MinDistance then
                if not spawned then
                    spawned = true
                    SpawnOpium(math.random(7,25))
                end
            else
                for _,opium in pairs(Opiums) do
                    DeleteEntity(opium)
                end
                spawned = false
            end
        end
    end)



    RegisterNetEvent('freezy_drugs:pickOpium')
    AddEventHandler('freezy_drugs:pickOpium',function()
        if freezy.Drugs['Opium Field'].NeededItem then
            local count = lib.callback.await('ox_inventory:getItemCount', false, freezy.Drugs['Opium Field'].NeededItem)
            if count > 0 then
                TaskStartScenarioInPlace(PlayerPedId(),'WORLD_HUMAN_GARDENER_PLANT',0,true)
                lib.progressCircle({
                    duration = math.random(4000,6000),
                    position = 'bottom',
                    useWhileDead = false,
                    canCancel = true,
                    label = Locale[freezy.Locale].PickingOpium,
                    disable = {
                        car = true,
                        move = true,
                        combat = true,
                    },
                })
                ClearPedTasks(PlayerPedId())
                DeleteEntity(lib.getNearbyObjects(GetEntityCoords(PlayerPedId()), 2.1)[1]['object'])
                exports.ox_target:removeZone('sphere')
                TriggerServerEvent('freezy_drugs:pickedOpium')
                Citizen.Wait(math.random(6000,15000))
                if math.random(1,2) == 1 then
                    SpawnOpium(1)
                end

            else
                lib.notify({
                    title = Locale[freezy.Locale].NotifyOpium,
                    description = Locale[freezy.Locale].MissingItem:format(freezy.Drugs['Opium Field'].NeededItem),
                    type = 'error'
                })
            end
        else
            TaskStartScenarioInPlace(PlayerPedId(),'WORLD_HUMAN_GARDENER_PLANT',0,true)
            lib.progressCircle({
                duration = math.random(6000,8000),
                position = 'bottom',
                useWhileDead = false,
                canCancel = true,
                label = Locale[freezy.Locale].PickingOpium,
                disable = {
                    car = true,
                    move = true,
                    combat = true,
                },

            })
            ClearPedTasks(PlayerPedId())
            
                DeleteEntity(lib.getNearbyObjects(GetEntityCoords(PlayerPedId()), 2.1)[1]['object'])
                TriggerServerEvent('freezy_drugs:pickedOpium')
                Citizen.Wait(math.random(6000,15000))
                if math.random(1,2) == 1 then
                SpawnOpium(1)
                end

        end
    end)

    AddEventHandler('onResourceStop', function(resource)
        if resource == GetCurrentResourceName() then
            for k, v in pairs(Opiums) do
                SetEntityAsMissionEntity(v, false, true)
                DeleteObject(v)
            end
        end
    end)
end
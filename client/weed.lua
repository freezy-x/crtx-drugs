if freezy.EnableDrugs.Weed then
    local spawned = false
    local weedModel = freezy.Drugs['Weed Field'].Model
    local weeds = {}


    function SpawnWeed(count)
        for i=0, count-1 do
        coordsx = freezy.Drugs['Weed Field'].Coords.x+math.random(8,20)
        coordsy = freezy.Drugs['Weed Field'].Coords.y+math.random(10,30)
        coordsz = freezy.Drugs['Weed Field'].Coords.z-1
        weed = CreateObject(weedModel, coordsx,coordsy,coordsz,true, true, false)
        PlaceObjectOnGroundProperly(weed)
        table.insert(weeds,weed)
        FreezeEntityPosition(weed,true)
        end
    end
    Citizen.CreateThread(function ()
        Citizen.Wait(1000)
        while true do
            Wait(1000)
            if GetDistanceBetweenCoords(freezy.Drugs['Weed Field'].Coords.x,freezy.Drugs['Weed Field'].Coords.y,freezy.Drugs['Weed Field'].Coords.z,GetEntityCoords(PlayerPedId())) <= freezy.MinDistance then
                if not spawned then
                    spawned = true
                    SpawnWeed(math.random(7,25))
                end
            else
                for _,weed in pairs(weeds) do
                    DeleteEntity(weed)
                end
                spawned = false
            end
        end
    end)
    local options = {
        {
            canInteract = function(_, distance, _)
                if IsEntityDead(PlayerPedId()) then
                    return false
                end
                if distance >= 2.0 then
                    return false
                end
                return true
            end,
            event = 'freezy_drugs:pickWeed',
            icon = 'fa-solid fa-cannabis',
            label = Locale[freezy.Locale].PickWeed,
            distance = 2.1
        }
    }
    exports.ox_target:addModel(weedModel, options)



    RegisterNetEvent('freezy_drugs:pickWeed')
    AddEventHandler('freezy_drugs:pickWeed',function()
		local playerPed = PlayerPedId()
        local count = lib.callback.await('ox_inventory:getItemCount', false, freezy.Drugs['Weed Field'].NeededItem.itemName)
        local muscleweight = lib.skillCheck({'easy', 'easy', 'easy'})
        if count > 0 then
            if muscleweight then
                TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
            lib.progressCircle({
                duration = math.random(4000,6000),
                position = 'bottom',
                useWhileDead = false,
                canCancel = false,
                label = Locale[freezy.Locale].PickingWeed,
                disable = {
                    car = true,
                    move = true,
                    combat = true,
                },
            })
            ClearPedTasks(playerPed)
            DeleteEntity(lib.getNearbyObjects(GetEntityCoords(PlayerPedId()), 2.1)[1]['object'])
            TriggerServerEvent('freezy_drugs:pickedWeed')
            Citizen.Wait(math.random(6000,15000))
            Spawncoke(1)
        else
        
        lib.notify({
            title = 'Error',
            description = Locale[freezy.Locale].Cancelled,
            type = 'error'
        })
    end
            
        else
            lib.notify({
                title = Locale[freezy.Locale].CokeField,
                -- description = "You don't have the required item! You need "..string.upper(freezy.Drugs['Coke Field'].NeededItem),
                description = Locale[freezy.Locale].MissingItem:format(freezy.Drugs['Coke Field'].NeededItem.label),
                type = 'error'
            })
    end
    end)

    for k,v in pairs(freezy.Drugs['Weed Production']) do
        exports.ox_target:addSphereZone({
            coords = vec3(freezy.Drugs['Weed Production'].Coords.x,freezy.Drugs['Weed Production'].Coords.y,freezy.Drugs['Weed Production'].Coords.z),
            radius = 1,
            options = {
                {
                    canInteract = function(_, distance, _)
                        if IsEntityDead(PlayerPedId()) then
                            return false
                        end
                        if distance >= 2.0 then
                            return false
                        end
                        return true
                    end,
                    event = 'freezy_drugs:enterWeedFacility',
                    distance = 2,
                    icon = 'fa-solid fa-door-open',
                    label = Locale[freezy.Locale].EnterWeed,
                }
            }
        })
        exports.ox_target:addSphereZone({
            coords = vec3(1066.3049+0.34, -3183.4141, -39.1635),
            radius = 1,
            options = {
                {
                    canInteract = function(_, distance, _)
                        if IsEntityDead(PlayerPedId()) then
                            return false
                        end
                        if distance >= 2.0 then
                            return false
                        end
                        return true
                    end,
                    event = 'freezy_drugs:exitWeedFacility',
                    distance = 2,
                    icon = 'fa-solid fa-right-to-bracket',
                    label = Locale[freezy.Locale].ExitWeed,
                }
            }
        })
        exports.ox_target:addSphereZone({
            coords = vec3(1038.4650, -3205.7244, -38.3010),
            radius = 1,
            options = {
                {
                    canInteract = function(_, distance, _)
                        if IsEntityDead(PlayerPedId()) then
                            return false
                        end
                        if distance >= 2.0 then
                            return false
                        end
                        return true
                    end,
                    event = 'freezy_drugs:startProcessWeed',
                    icon = 'fa-solid fa-pills',
                    label = Locale[freezy.Locale].ProcessWeed,
                }
            }
        })
        exports.ox_target:addSphereZone({
            coords = vec3(1036.8458, -3203.0762, -38.3086),
            radius = 1,
            options = {
                {
                    canInteract = function(_, distance, _)
                        if IsEntityDead(PlayerPedId()) then
                            return false
                        end
                        if distance >= 2.0 then
                            return false
                        end
                        return true
                    end,
                    event = 'freezy_drugs:startProcessWeed1',
                    icon = 'fa-solid fa-pills',
                    label = Locale[freezy.Locale].ProcessWeed,
                }
            }
        })
    end

    RegisterNetEvent('freezy_drugs:enterWeedFacility')
    AddEventHandler('freezy_drugs:enterWeedFacility',function ()
        DoScreenFadeOut(2000)
        lib.progressCircle({
            duration = 4000,
            position = 'bottom',
            label = Locale[freezy.Locale].EnteringWeed,
            useWhileDead = false,
            canCancel = false,
            disable = {
                move = true,
                car = true,
                combat = true
            },
        })
        -- Citizen.Wait(2500)
        SetEntityCoords(PlayerPedId(),1066.3049+0.34, -3183.4141, -39.1635-1,true,false,false,false)
        SetEntityHeading(PlayerPedId(),271.0252)
        DoScreenFadeIn(2000)
    end)
    RegisterNetEvent('freezy_drugs:exitWeedFacility')
    AddEventHandler('freezy_drugs:exitWeedFacility',function ()
        DoScreenFadeOut(2000)
        lib.progressCircle({
            duration = 4000,
            position = 'bottom',
            label = Locale[freezy.Locale].ExitingWeed,
            useWhileDead = false,
            canCancel = false,
            disable = {
                move = true,
                car = true,
                combat = true
            },
        })
        -- Citizen.Wait(2500)
        SetEntityCoords(PlayerPedId(),freezy.Drugs['Weed Production'].Coords.x,freezy.Drugs['Weed Production'].Coords.y,freezy.Drugs['Weed Production'].Coords.z-1,true,false,false,false)
        DoScreenFadeIn(2000)
    end)
    RegisterNetEvent('freezy_drugs:startProcessWeed')
    AddEventHandler('freezy_drugs:startProcessWeed',function ()
        lib.registerContext({
            id = 'weedoptions',
            title = 'Weed Processing',
            options = {
                {
                    canInteract = function(_, distance, _)
                        if IsEntityDead(PlayerPedId()) then
                            return false
                        end
                        if distance >= 2.0 then
                            return false
                        end
                        return true
                    end,
                    title = Locale[freezy.Locale].WeedPack,
                    icon = "fas fa-box",
                    image = "https://cdn.discordapp.com/attachments/1126971528240697444/1127567431884349530/banana_kush_bag.png",
                    arrow = true,
                    event = "freezy_drugs:processWeedPack",
                },
            }
        })
        lib.showContext('weedoptions')

        -- TriggerServerEvent('freezy_drugs:processWeed')

        -- TriggerServerEvent('freezy_drugs:processedWeed')
    end)
    RegisterNetEvent('freezy_drugs:startProcessWeed1')
    AddEventHandler('freezy_drugs:startProcessWeed1',function ()
        lib.registerContext({
            id = 'weedoptions',
            title = 'Weed Processing',
            options = {
                {
                    canInteract = function(_, distance, _)
                        if IsEntityDead(PlayerPedId()) then
                            return false
                        end
                        if IsPedArmed(PlayerPedId(),4) then return freezy.AllowProcessingWhenArmed end
                        if distance >= 2.0 then
                            return false
                        end
                        return true
                    end,
                    title = Locale[freezy.Locale].Joint,
                    icon = "fas fa-joint",
                    image = "https://cdn.discordapp.com/attachments/1126971528240697444/1127594408896888832/weed_joint.png",
                    arrow = true,
                    event = "freezy_drugs:processWeedJoint",
                }
            }
        })
        lib.showContext('weedoptions')

        -- TriggerServerEvent('freezy_drugs:processWeed')

        -- TriggerServerEvent('freezy_drugs:processedWeed')
    end)

    RegisterNetEvent('freezy_drugs:processWeedJoint')
    AddEventHandler('freezy_drugs:processWeedJoint',function ()
        local count = lib.callback.await('ox_inventory:getItemCount', false, 'weed_leaf')
        local count2 = lib.callback.await('ox_inventory:getItemCount', false, 'rolling_paper')
        if count >= freezy.Drugs['Weed Production'].NeededWeedForJoint and count2 >= 1 then
            lib.progressCircle({
                duration = 6000,
                position = 'bottom',
                label = Locale[freezy.Locale].ProcessingJoint,
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true,
                    move = true,
                    combat = true
                },
                anim = {
                    dict = 'mp_arresting',
                    clip = 'a_uncuff'
                },
                prop = {
                    model = `p_amb_joint_01`,
                    pos = vec3(0.013, 0.03, 0.022),
                    rot = vec3(0.0, 0.0, -1.5)
                },
            })
            TriggerServerEvent('freezy_drugs:processedWeedJoint')

        else
            lib.notify({
                title = Locale[freezy.Locale].NotifyWeedProc,
                description = Locale[freezy.Locale].ItemsMissing,
                type = 'error'
            })
        end
    end)
    RegisterNetEvent('freezy_drugs:processWeedPack')
    AddEventHandler('freezy_drugs:processWeedPack',function ()
        local count = lib.callback.await('ox_inventory:getItemCount', false, 'weed_leaf')
        local count2 = lib.callback.await('ox_inventory:getItemCount', false, 'empty_bag')
        if count >= freezy.Drugs['Weed Production'].NeededWeedForPack and count2 >= 1 then
            lib.progressCircle({
                duration = 6000,
                position = 'bottom',
                label = Locale[freezy.Locale].ProcessingWeedPack,
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true,
                    move = true,
                    combat = true
                },
                anim = {
                    dict = 'mp_arresting',
                    clip = 'a_uncuff'
                },

            })
            TriggerServerEvent('freezy_drugs:processedWeedPack')
        else
            lib.notify({
                title = Locale[freezy.Locale].NotifyWeedProc,
                description = Locale[freezy.Locale].ItemsMissing,
                type = 'error'
            })
        end
    end)


    AddEventHandler('onResourceStop', function(resource)
        if resource == GetCurrentResourceName() then
            for k, v in pairs(weeds) do
                SetEntityAsMissionEntity(v, false, true)
                DeleteObject(v)
            end
        end
    end)
end
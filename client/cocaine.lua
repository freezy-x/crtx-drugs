if freezy.EnableDrugs.Cocaine then

    local spawned = false

    local cokes = {}


    function Spawncoke(count)
        for i=0, count-1 do
        local coordsx = freezy.Drugs['Coke Field'].Coords.x+math.random(1,16)
        local coordsy = freezy.Drugs['Coke Field'].Coords.y+math.random(1,16)
        local coordsz = freezy.Drugs['Coke Field'].Coords.z-1
        local coke = CreateObject('prop_plant_01a', coordsx,coordsy,coordsz,true, true, false)
        PlaceObjectOnGroundProperly(coke)
        table.insert(cokes,coke)
        FreezeEntityPosition(coke,true)
        end
    end
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
            event = 'freezy_drugs:pickCoke',
            icon = 'fa-solid fa-pills',
            label = Locale[freezy.Locale].PickCoke,
            distance = 2.1
        }
    }
    exports.ox_target:addModel(`prop_plant_01a`, options)

    -- Distance checking for spawning
    Citizen.CreateThread(function ()
        Citizen.Wait(1000)
        while true do
            Wait(1000)
            if GetDistanceBetweenCoords(freezy.Drugs['Coke Field'].Coords.x,freezy.Drugs['Coke Field'].Coords.y,freezy.Drugs['Coke Field'].Coords.z,GetEntityCoords(PlayerPedId())) <= freezy.MinDistance then
                if not spawned then
                    spawned = true
                    Spawncoke(math.random(7,25))
                end
            else
                for _,coke in pairs(cokes) do
                    DeleteEntity(coke)
                end
                spawned = false
            end
        end
    end)



    RegisterNetEvent('freezy_drugs:pickCoke')
    AddEventHandler('freezy_drugs:pickCoke',function()
        local playerPed = PlayerPedId()
        local count = lib.callback.await('ox_inventory:getItemCount', false, freezy.Drugs['Coke Field'].NeededItem.itemName)
        local muscleweight = lib.skillCheck({'easy', 'easy', 'easy'})
        if count > 0 then
            if muscleweight then
                TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
            lib.progressCircle({
                duration = math.random(4000,6000),
                position = 'bottom',
                useWhileDead = false,
                canCancel = false,
                label = Locale[freezy.Locale].PickingCoke,
                disable = {
                    car = true,
                    move = true,
                    combat = true,
                },
            })
            ClearPedTasks(playerPed)
            DeleteEntity(lib.getNearbyObjects(GetEntityCoords(PlayerPedId()), 2.1)[1]['object'])
            
            TriggerServerEvent('freezy_drugs:pickedCoke')
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

    for k,v in pairs(freezy.Drugs['Coke Production']) do
        exports.ox_target:addSphereZone({
            coords = vec3(freezy.Drugs['Coke Production'].Coords.x,freezy.Drugs['Coke Production'].Coords.y,freezy.Drugs['Coke Production'].Coords.z),
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
                    event = 'freezy_drugs:enterCokeFacility',
                    distance = 2,
                    icon = 'fa-solid fa-door-open',
                    label = Locale[freezy.Locale].EnterCoke,
                }
            }
        })
        exports.ox_target:addSphereZone({
            coords = vec3(1088.6289, -3187.5061, -38.9935),
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
                    event = 'freezy_drugs:exitCokeFacility',
                    distance = 2,
                    icon = 'fa-solid fa-right-to-bracket',
                    label = Locale[freezy.Locale].ExitCoke,
                }
            }
        })
        exports.ox_target:addSphereZone({
            coords = vec3(1092.9498, -3196.6692+.7, -38.9935-.2),
            radius = 1,
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
                    event = 'freezy_drugs:startProcessCoke',
                    icon = 'fa-solid fa-pills',
                    distance = 1,
                    label = Locale[freezy.Locale].ProcessCoke,
                }
            }
        })
        exports.ox_target:addSphereZone({
            coords = vec3(1095.4216, -3196.6531+.7, -38.9935-.2),
            radius = 1,
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
                    event = 'freezy_drugs:startProcessCoke',
                    icon = 'fa-solid fa-pills',
                    distance = 1,
                    label = Locale[freezy.Locale].ProcessCoke,
                }
            }
        })
        exports.ox_target:addSphereZone({
            coords = vec3(1090.2649, -3195.8254, -39.0301),
            radius = 1,
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
                    event = 'freezy_drugs:startProcessCoke',
                    icon = 'fa-solid fa-pills',
                    distance = 1,
                    label = Locale[freezy.Locale].ProcessCoke,
                }
            }
        })
        exports.ox_target:addSphereZone({
            coords = vec3(1101.8198, -3193.7742+1, -38.9935-.2),
            radius = 1,
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
                    event = 'freezy_drugs:startProcessCoke1',
                    icon = 'fa-solid fa-pills',
                    distance = 1,
                    label = Locale[freezy.Locale].ProcessCoke,
                }
            }
        })
        exports.ox_target:addSphereZone({
            coords = vec3(1099.5487-1, -3194.1365, -38.9935-.2),
            radius = 1,
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
                    event = 'freezy_drugs:startProcessCoke1',
                    icon = 'fa-solid fa-pills',
                    distance = 1,
                    label = Locale[freezy.Locale].ProcessCoke,
                }
            }
        })
    end

    RegisterNetEvent('freezy_drugs:enterCokeFacility')
    AddEventHandler('freezy_drugs:enterCokeFacility',function ()
        DoScreenFadeOut(2000)
        lib.progressCircle({
            position = 'bottom',
            duration = 4000,
            label = Locale[freezy.Locale].EnteringCoke,
            useWhileDead = false,
            canCancel = false,
            disable = {
                move = true,
                car = true,
                combat = true
            },
        })
        -- Citizen.Wait(2500)
        SetEntityCoords(PlayerPedId(),1088.5941, -3187.5061, -38.9935-1,true,false,false,false)
        SetEntityHeading(PlayerPedId(),175.0252)
        DoScreenFadeIn(2000)
    end)
    RegisterNetEvent('freezy_drugs:exitCokeFacility')
    AddEventHandler('freezy_drugs:exitCokeFacility',function ()
        DoScreenFadeOut(2000)
        lib.progressCircle({
            position = 'bottom',
            duration = 4000,
            label = Locale[freezy.Locale].ExitingCoke,
            useWhileDead = false,
            canCancel = false,
            disable = {
                move = true,
                car = true,
                combat = true
            },
        })
        -- Citizen.Wait(2500)
        SetEntityCoords(PlayerPedId(),freezy.Drugs['Coke Production'].Coords.x,freezy.Drugs['Coke Production'].Coords.y,freezy.Drugs['Coke Production'].Coords.z-1,true,false,false,false)
        DoScreenFadeIn(2000)
    end)
    RegisterNetEvent('freezy_drugs:startProcessCoke')
    AddEventHandler('freezy_drugs:startProcessCoke',function ()
        lib.registerContext({
            id = 'Cokeoptions',
            title = Locale[freezy.Locale].CokeProcessing,
            options = {
                {
                    title = Locale[freezy.Locale].Coke,
                    icon = "fas fa-tablets",
                    image = "https://cdn.discordapp.com/attachments/1126971528240697444/1127594594838786119/coke.png",
                    arrow = true,
                    event = "freezy_drugs:processCokeBag1",
                }
            }
        })
        lib.showContext('Cokeoptions')

        -- TriggerServerEvent('freezy_drugs:processCoke')

        -- TriggerServerEvent('freezy_drugs:processedCoke')
    end)

    RegisterNetEvent('freezy_drugs:startProcessCoke1')
    AddEventHandler('freezy_drugs:startProcessCoke1',function ()
        lib.registerContext({
            id = 'Cokeoptions',
            title = Locale[freezy.Locale].CokeProcessing,
            options = {
                {
                    title = Locale[freezy.Locale].CokeBag,
                    icon = "fas fa-tablets",
                    image = "https://cdn.discordapp.com/attachments/1126971528240697444/1127594409203085383/coke_bag.png",
                    arrow = true,
                    event = "freezy_drugs:processCokeBag",
                },
                {
                    title = Locale[freezy.Locale].CokeBrick,
                    icon = "fas fa-box-open",
                    image = "https://cdn.discordapp.com/attachments/1126971528240697444/1127594409442168942/coke_brick.png",
                    arrow = true,
                    event = "freezy_drugs:processCokeBrick",
                }
            }
        })
        lib.showContext('Cokeoptions')

        -- TriggerServerEvent('freezy_drugs:processCoke')

        -- TriggerServerEvent('freezy_drugs:processedCoke')
    end)

    RegisterNetEvent('freezy_drugs:processCokeBag')
    AddEventHandler('freezy_drugs:processCokeBag',function ()
        local count = lib.callback.await('ox_inventory:getItemCount', false, 'coke')
        local count2 = lib.callback.await('ox_inventory:getItemCount', false, 'empty_bag')
        if count >= freezy.Drugs['Coke Production'].NeededCokeForBag and count2 >= 1 then
            lib.progressCircle({
                duration = math.random(freezy.Drugs['Coke Production'].ProcessingTime[1],freezy.Drugs['Coke Production'].ProcessingTime[2]),
                position = 'bottom',
                label = Locale[freezy.Locale].ProcessingCoke,
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true,
                    move = true,
                    combat = true
                },
                anim = {
                    dict = 'anim@amb@business@coc@coc_unpack_cut_left@',
                    clip = 'coke_cut_coccutter'
                },
                prop = {
                    model = `prop_cs_business_card`,
                    pos = vec3(0.113, 0.03, 0.022),
                    rot = vec3(0.0, 0.0, -1.5)
                },
            })
            TriggerServerEvent('freezy_drugs:processedCokeBag')

        else
            lib.notify({
                title = Locale[freezy.Locale].CokeProcessing,
                description = Locale[freezy.Locale].ItemsMissing,
                type = 'error'
            })
        end
    end)

    RegisterNetEvent('freezy_drugs:processCokeBag1')
    AddEventHandler('freezy_drugs:processCokeBag1',function ()
        local count = lib.callback.await('ox_inventory:getItemCount', false, 'coke_leaf')
        if count >= freezy.Drugs['Coke Production'].NeededLeafForCoke then
            lib.progressCircle({
                duration = math.random(freezy.Drugs['Coke Production'].ProcessingTime[1],freezy.Drugs['Coke Production'].ProcessingTime[2]),
                position = 'bottom',
                label = Locale[freezy.Locale].ProcessingCoke,
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true,
                    move = true,
                    combat = true
                },
                anim = {
                    dict = 'anim@amb@business@coc@coc_unpack_cut_left@',
                    clip = 'coke_cut_coccutter'
                },
                prop = {
                    model = `prop_cs_business_card`,
                    pos = vec3(0.113, 0.03, 0.022),
                    rot = vec3(0.0, 0.0, -1.5)
                },
            })
            TriggerServerEvent('freezy_drugs:processedCokeBag1')

        else
            lib.notify({
                title = Locale[freezy.Locale].CokeProcessing,
                description = Locale[freezy.Locale].ItemsMissing,
                type = 'error'
            })
        end
    end)


    local powder = CreateObject('h4_prop_h4_coke_tablepowder', 1092.8567, -3195.7323, -39.1933,true, true, false)
    local cleaner = CreateObject('h4_prop_h4_powdercleaner_01a', 1092.2567, -3195.7323, -39.1933,true, true, false)
    -- DeleteEntity()
    local cleaner = CreateObject('prop_plant_01b', 1007.2787, -3198.2700, -38.9932,true, true, false)


    RegisterNetEvent('freezy_drugs:processCokeBrick')
    AddEventHandler('freezy_drugs:processCokeBrick',function ()
        local count = lib.callback.await('ox_inventory:getItemCount', false, 'coke')
        -- local count2 = lib.callback.await('ox_inventory:getItemCount', false, 'empty_bag')
        if count >= freezy.Drugs['Coke Production'].NeededCokeForBrick then
            lib.progressCircle({
                duration = 12000,
                position = 'bottom',
                label = Locale[freezy.Locale].ProcessingCokeBrick,
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true,
                    move = true,
                    combat = true
                },
                anim = {
                    dict = 'anim@amb@business@coc@coc_unpack_cut_left@',
                    clip = 'coke_cut_coccutter'
                },
                prop = {
                    model = `prop_cs_business_card`,
                    pos = vec3(0.113, 0.03, 0.022),
                    rot = vec3(0.0, 0.0, -1.5)
                },
            })
            TriggerServerEvent('freezy_drugs:processedCokeBrick')
        else
            lib.notify({
                title = Locale[freezy.Locale].CokeProcessing,
                description = Locale[freezy.Locale].ItemsMissing,
                type = 'error'
            })
        end
    end)

    AddEventHandler('onResourceStop', function(resource)
        if resource == GetCurrentResourceName() then
            for k, v in pairs(cokes) do
                SetEntityAsMissionEntity(v, false, true)
                DeleteObject(v)
            end
        end
    end)
end
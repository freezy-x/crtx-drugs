if freezy.EnableDrugs.Meth then

    local spawned = false


    local Meths = {}

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
            event = 'freezy_drugs:pickMeth',
            icon = 'fa-solid fa-vial',
            label = Locale[freezy.Locale].PickChems,
        }
    }
    exports.ox_target:addModel(`prop_barrel_03d`, options)

    RegisterNetEvent('freezy_drugs:pickMeth')
    AddEventHandler('freezy_drugs:pickMeth',function()
        if freezy.Drugs['Meth'].NeededItem then
            local count = lib.callback.await('ox_inventory:getItemCount', false, freezy.Drugs['Meth'].NeededItem.itemName)
            if count > 0 then
                lib.progressCircle({
                    duration = math.random(4000,6000),
                    position = 'bottom',
                    useWhileDead = false,
                    canCancel = false,
                    label = Locale[freezy.Locale].PickingChems,
                    disable = {
                        car = true,
                        move = true,
                        combat = true,
                    },
                    anim = {
                        dict = 'amb@world_human_gardener_plant@female@base',
                        clip = 'base_female'
                    },
                })
                          
                    TriggerServerEvent('freezy_drugs:pickedMeth')
                    Citizen.Wait(math.random(6000,15000))
                    if math.random(1,2) == 1 then
                    end
                    

            else
                lib.notify({
                    title = 'Meth',
                    description = "You don't have the required item! You need "..freezy.Drugs['Meth'].NeededItem.label,
                    type = 'error'
                })
            end
        else
            lib.progressCircle({
                duration = math.random(4000,6000),
                position = 'bottom',
                useWhileDead = false,
                canCancel = false,
                label = Locale[freezy.Locale].PickingChems,
                disable = {
                    car = true,
                    move = true,
                    combat = true,
                },
                anim = {
                    dict = 'amb@world_human_gardener_plant@female@base',
                    clip = 'base_female'
                },
            })
            DeleteEntity(lib.getNearbyObjects(GetEntityCoords(PlayerPedId()), 2.1)[1]['object'])
            TriggerServerEvent('freezy_drugs:pickedMeth')
            Citizen.Wait(math.random(6000,15000))
            if math.random(1,2) == 1 then
                SpawnMeth(1)
            end
        end
    end)

    for k,v in pairs(freezy.Drugs['Meth Production']) do
        exports.ox_target:addSphereZone({
            coords = vec3(freezy.Drugs['Meth Production'].Coords.x,freezy.Drugs['Meth Production'].Coords.y,freezy.Drugs['Meth Production'].Coords.z),
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
                    name = 'sphere',
                    event = 'freezy_drugs:enterMethFacility',
                    icon = 'fa-solid fa-door-open',
                    label = Locale[freezy.Locale].EnterMeth,
                }
            }
        })
        exports.ox_target:addSphereZone({
            coords = vec3(996.8490, -3200.7773, -36.3937),
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
                    name = 'sphere',
                    event = 'freezy_drugs:exitMethFacility',
                    icon = 'fa-solid fa-right-to-bracket',
                    label = Locale[freezy.Locale].ExitMeth,
                }
            }
        })
        exports.ox_target:addSphereZone({
            coords = vec3(1012.3339, -3194.9626+.8, -38.9931-.3),
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
                    name = 'sphere',
                    event = 'freezy_drugs:methToBag',
                    icon = 'fa-solid fa-pills',
                    label = Locale[freezy.Locale].ProcessMeth,
                }
            }
        })
        exports.ox_target:addSphereZone({
            coords = vec3(1005.7512, -3200.3413-0.5, -38.5193),
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
                    name = 'sphere',
                    event = 'freezy_drugs:processAcid',
                    icon = 'fa-solid fa-flask',
                    label = Locale[freezy.Locale].ProcessAcid,
                }
            }
        })
    end

    RegisterNetEvent('freezy_drugs:enterMethFacility')
    AddEventHandler('freezy_drugs:enterMethFacility',function ()
    exports["memorygame"]:thermiteminigame(4, 3, 5, 5,
      function()
        DoScreenFadeOut(2000)
        lib.progressCircle({
            duration = 4000,
            position = 'bottom',
            label = Locale[freezy.Locale].EnteringMeth,
            useWhileDead = false,
            canCancel = false,
            disable = {
                move = true,
                car = true,
                combat = true
            },
        })
        -- Citizen.Wait(2500)
        SetEntityCoords(PlayerPedId(),996.8334, -3200.7859, -36.3937-1,true,false,false,false)
        SetEntityHeading(PlayerPedId(),271.0252)
        DoScreenFadeIn(2000)
    end)
end)
    RegisterNetEvent('freezy_drugs:exitMethFacility')
    AddEventHandler('freezy_drugs:exitMethFacility',function ()
        DoScreenFadeOut(2000)
        lib.progressCircle({
            position = 'bottom',
            duration = 4000,
            label = Locale[freezy.Locale].ExitingMeth,
            useWhileDead = false,
            canCancel = false,
            disable = {
                move = true,
                car = true,
                combat = true
            },
        })
        -- Citizen.Wait(2500)
        SetEntityCoords(PlayerPedId(),freezy.Drugs['Meth Production'].Coords.x,freezy.Drugs['Meth Production'].Coords.y,freezy.Drugs['Meth Production'].Coords.z-1,true,false,false,false)
        DoScreenFadeIn(2000)
    end)
    RegisterNetEvent('freezy_drugs:methToBag')
    AddEventHandler('freezy_drugs:methToBag',function ()
        local count = lib.callback.await('ox_inventory:getItemCount', false, 'pure_meth')
        local count2 = lib.callback.await('ox_inventory:getItemCount', false, 'empty_bag')
        if count >= freezy.Drugs['Meth Production'].NeededMeth and count2 >= 1 then

            lib.progressCircle({
                duration = 10000,
                position = 'bottom',
                label = Locale[freezy.Locale].ProcessingMeth,
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true,
                    move = true,
                    combat = true
                },
                anim = {
                    dict = 'anim@amb@business@meth@meth_smash_weight_check@',
                    clip = 'break_weigh_v2_char01'
                },
            })
            TriggerServerEvent('freezy_drugs:processedMeth')

        else
            lib.notify({
                title = Locale[freezy.Locale].NotifyMeth,
                description = Locale[freezy.Locale].ItemsMissing,
                type = 'error'
            })
        end
    end)
    exports.ox_target:addSphereZone({
        coords = vec3(1005.9760, -3195.0344, -38.9932),
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
                name = 'wash',
                event = 'freezy_drugs:wash',
                icon = 'fas fa-hands-wash',
                label = Locale[freezy.Locale].Wash,
            }
        }
    })
    RegisterNetEvent('freezy_drugs:wash')
    AddEventHandler('freezy_drugs:wash',function ()

            lib.progressCircle({
                duration = 5000,
                position = 'bottom',
                label = Locale[freezy.Locale].WashProgress,
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true,
                    move = true,
                    combat = true
                },
                anim = {
                    dict = 'mini@repair',
                    clip = 'fixing_a_ped'
                },
            })
    end)
    RegisterNetEvent('freezy_drugs:processAcid')
    AddEventHandler('freezy_drugs:processAcid',function ()
        local count = lib.callback.await('ox_inventory:getItemCount', false, 'phosphoric_acid')
        if count >= freezy.Drugs['Meth Production'].NeededAcid then

            lib.progressCircle({
                duration = math.random(8000,16000),
                position = 'bottom',
                label = Locale[freezy.Locale].ProcessingAcid,
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true,
                    move = true,
                    combat = true
                },
                anim = {
                    dict = 'anim@amb@business@meth@meth_monitoring_cooking@cooking@',
                    clip = 'look_around_v8_cooker'
                },
            })
            TriggerServerEvent('freezy_drugs:processedAcid')

        else
            lib.notify({
                title = Locale[freezy.Locale].NotifyMeth,
                description = Locale[freezy.Locale].ItemsMissing,
                type = 'error'
            })
        end
    end)

    AddEventHandler('onResourceStop', function(resource)
        if resource == GetCurrentResourceName() then
            for k, v in pairs(Meths) do
                SetEntityAsMissionEntity(v, false, true)
                DeleteObject(v)
            end
        end
    end)
end
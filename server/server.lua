RegisterServerEvent('freezy_drugs:pickedWeed')
AddEventHandler('freezy_drugs:pickedWeed',function()
    if exports.ox_inventory:CanCarryItem(source, 'weed_leaf',freezy.Drugs['Weed Field'].MaxCount) then

    exports.ox_inventory:AddItem(source, 'weed_leaf', math.random(freezy.Drugs['Weed Field'].MinCount,freezy.Drugs['Weed Field'].MaxCount))
    else
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = "You can't carry more of this drug type"
        })
    end
end)
if freezy.sellingMode == 'manual' then
    RegisterCommand(freezy.sellingCommand, function(source, _, _)
        if source ~= 0 then
            TriggerClientEvent('freezy_drugselling:sellMode', source)
        end
    end, false)
end

RegisterServerEvent('freezy_drugs:pickedCoke')
AddEventHandler('freezy_drugs:pickedCoke',function()
    if exports.ox_inventory:CanCarryItem(source, 'coke_leaf',freezy.Drugs['Coke Field'].MaxCount) then

    exports.ox_inventory:AddItem(source, 'coke_leaf', math.random(freezy.Drugs['Coke Field'].MinCount,freezy.Drugs['Coke Field'].MaxCount))
    else
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = "You can't carry more of this drug type"
        })
    end
end)

RegisterServerEvent('freezy_drugs:pickedMeth')
AddEventHandler('freezy_drugs:pickedMeth',function()
    if exports.ox_inventory:CanCarryItem(source, 'phosphoric_acid', freezy.Drugs['Meth'].MaxCount) then
    if not freezy.Drugs['Meth'].NeededItem then
        exports.ox_inventory:AddItem(source, 'phosphoric_acid', math.random(freezy.Drugs['Meth'].MinCount,freezy.Drugs['Meth'].MaxCount))
    else
        local success = exports.ox_inventory:RemoveItem(source, 'empty_canister', 1)
        if success then
            exports.ox_inventory:AddItem(source, 'phosphoric_acid', math.random(freezy.Drugs['Meth'].MinCount,freezy.Drugs['Meth'].MaxCount))
            else
                TriggerClientEvent('ox_lib:notify', source, {
                    type = 'error',
                    description = "You can't carry more of this drug type"
                })
            end
        end
    end
end)
RegisterServerEvent('freezy_drugs:pickedOpium')
AddEventHandler('freezy_drugs:pickedOpium',function()
    if exports.ox_inventory:CanCarryItem(source, 'opium', freezy.Drugs['Opium Field'].MaxCount) then

    exports.ox_inventory:AddItem(source, 'opium', math.random(freezy.Drugs['Opium Field'].MinCount,freezy.Drugs['Opium Field'].MaxCount))
    else
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = "You can't carry more of this drug type"
        })
    end
end)

RegisterServerEvent('freezy_drugs:processedWeedPack')
AddEventHandler('freezy_drugs:processedWeedPack',function()
    local success = exports.ox_inventory:RemoveItem(source, 'weed_leaf', freezy.Drugs['Weed Production'].NeededWeedForPack)
    local success1 = exports.ox_inventory:RemoveItem(source, 'empty_bag', 1)
    if success and success1 then
        exports.ox_inventory:AddItem(source, 'weed_package', 1)
    else
        print('cheater')
    end
end)
RegisterServerEvent('freezy_drugs:processedWeedJoint')
AddEventHandler('freezy_drugs:processedWeedJoint',function()
    local success1 = exports.ox_inventory:RemoveItem(source, 'weed_leaf', freezy.Drugs['Weed Production'].NeededWeedForJoint)
    local success = exports.ox_inventory:RemoveItem(source, 'rolling_paper', 1)
    if success1 and success then
        exports.ox_inventory:AddItem(source, 'weed_joint', 1)
    else
        print('cheater')
    end
end)
RegisterServerEvent('freezy_drugs:processedCokeBag')
AddEventHandler('freezy_drugs:processedCokeBag',function()
    local success = exports.ox_inventory:RemoveItem(source, 'coke', freezy.Drugs['Coke Production'].NeededCokeForBag)
    local success1 = exports.ox_inventory:RemoveItem(source, 'empty_bag', 1)
    if success and success1 then
        exports.ox_inventory:AddItem(source, 'coke_bag', 1)
    end
end)
RegisterServerEvent('freezy_drugs:processedCokeBag1')
AddEventHandler('freezy_drugs:processedCokeBag1',function()
    local success = exports.ox_inventory:RemoveItem(source, 'coke_leaf', freezy.Drugs['Coke Production'].NeededLeafForCoke)
    if success then
        exports.ox_inventory:AddItem(source, 'coke', 3)
    end
end)
RegisterServerEvent('freezy_drugs:processedCokeBrick')
AddEventHandler('freezy_drugs:processedCokeBrick',function()
    local success = exports.ox_inventory:RemoveItem(source, 'coke', freezy.Drugs['Coke Production'].NeededCokeForBrick)
    if success then
        exports.ox_inventory:AddItem(source, 'coke_brick', 1)
    else
        print('cheater')
    end
end)
RegisterServerEvent('freezy_drugs:processedMeth')
AddEventHandler('freezy_drugs:processedMeth',function()
    local success = exports.ox_inventory:RemoveItem(source, 'empty_bag', 1)
    local success1 = exports.ox_inventory:RemoveItem(source, 'pure_meth', freezy.Drugs['Meth Production'].NeededMeth)
    if success and success1 then
        exports.ox_inventory:AddItem(source, 'meth_bag', 1)
    else
        print('cheater')
    end
end)
RegisterServerEvent('freezy_drugs:processedAcid')
AddEventHandler('freezy_drugs:processedAcid',function()
    local success = exports.ox_inventory:RemoveItem(source, 'phosphoric_acid', freezy.Drugs['Meth Production'].NeededAcid)
    if success then
        exports.ox_inventory:AddItem(source, 'pure_meth', math.random(3,7))
    else
        print('Cheater')
    end
end)
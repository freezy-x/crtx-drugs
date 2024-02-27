ESX = exports["es_extended"]:getSharedObject()



for index, item in ipairs(freezy['Buy']) do
    RegisterServerEvent('buyItems_' .. index)
    AddEventHandler('buyItems_' .. index, function(count)
        local itemIndex = index
        local player = source
        local xPlayer = ESX.GetPlayerFromId(player)

        if not freezy['Buy'][itemIndex] then
            TriggerClientEvent('ox_lib:notify', player, { type = 'error', description = ''..Locale[freezy.Locale]['invaliditem']..' ' })
            return
        end

        local itemName = freezy['Buy'][itemIndex].name
        local itemLabel = freezy['Buy'][itemIndex].label
        local itemPrice = freezy['Buy'][itemIndex].price

        local totalPrice = itemPrice * count

        if xPlayer.getMoney() >= totalPrice then
            if xPlayer.canCarryItem(itemName, count) then
                xPlayer.removeMoney(totalPrice)
                xPlayer.addInventoryItem(itemName, count)
                TriggerClientEvent('ox_lib:notify', player, { type = 'success', description = ' '..Locale[freezy.Locale]['boughtitem']..' '..count..' '..itemLabel..' ' })
            else
                TriggerClientEvent('ox_lib:notify', player, { type = 'error', description = ''..Locale[freezy.Locale]['inventoryfull']..' ' })
            end
        else
            TriggerClientEvent('ox_lib:notify', player, { type = 'error', description = ''..Locale[freezy.Locale]['insufficientmoney']..' ' })
        end
    end)
end



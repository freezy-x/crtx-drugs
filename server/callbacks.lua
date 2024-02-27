lib.callback.register('freezy_drugselling:giveDrugs', function (_, drugName, drugAmount)
    return exports.ox_inventory:RemoveItem(source, drugName, drugAmount) -- Server side export for removing items
end)

-- Retrieve player's drugs in inventory
lib.callback.register('freezy_drugselling:getPlayerDrugs', function (_, sellableDrugNames)
    return exports.ox_inventory:Search(source, 'count', sellableDrugNames) -- Server side export for retrieving items from inventory
end)

-- Get online cops (ONLY WORKS IF ESX IS ENABLED)
if freezy.ESX then
    ESX = exports["es_extended"]:getSharedObject()
    ESX.RegisterServerCallback('freezy_drugselling:onlinePolice', function(source, cb)
        local police = 0

        for _, id in pairs(ESX.GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(id)
            for _,job in pairs(freezy.policeJobs) do
                if xPlayer.job.name == job then
                    police = police + 1
                end
            end
        end
        cb(police)
    end)
end

lib.callback.register('freezy_drugs:canCarry', function(source, item, count)
    if exports.ox_inventory:CanCarryItem(source, item, count) then
        return true
    else
        return false
    end

end)
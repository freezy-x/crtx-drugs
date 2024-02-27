RegisterNetEvent('freezy_drugselling:retrieve', function (drugName, drugAmount)
    exports.ox_inventory:AddItem(source, drugName, drugAmount) -- Server side export for adding items
end)

RegisterNetEvent('freezy_drugselling:pay', function (drugName, drugAmount)
    local price = math.random(freezy.Sell[drugName].priceRange[1], freezy.Sell[drugName].priceRange[2])

    exports.ox_inventory:AddItem(source, freezy.moneyItem, price * drugAmount) -- Server side export for adding items
end)
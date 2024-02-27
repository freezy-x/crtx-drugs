local cops = 0
local PlayerData = {}

if freezy.ESX then
    ESX = exports["es_extended"]:getSharedObject()
end


RegisterNetEvent('freezy_drugselling:sellMode', function ()
    if freezy.ESX then
        cops = 0
        ESX.TriggerServerCallback('freezy_drugselling:onlinePolice', function(_police)
            cops = _police
        end)
        ESX.TriggerServerCallback('freezy_drugselling:onlinePolice', function(_isCop)
            isCop = _isCop
        end)
        if cops < freezy.minimumPolice then
            lib.notify({
                title = Locale[freezy.Locale].NotifyTitle,
                description = Locale[freezy.Locale].NoCops:format(freezy.minimumPolice),
                icon='handcuffs',
                iconColor='#f38ba8',
                position='top',
            })
            return
        else
            sellMode()

        end
    else
        sellMode()
    end
end)

if freezy.sellingMode == 'auto' then
    AddEventHandler('playerSpawned', function()
        sellMode()
    end)
    sellMode()
end

if freezy.sellingMode ~= 'auto' then
    TriggerEvent('chat:addSuggestion', "/"..freezy.sellingCommand, Locale[freezy.Locale].ChatSuggestion)
end

Citizen.CreateThread(function()
    for k,v in pairs(freezy.Drugs) do
        if v.Blip then
            local blip = AddBlipForCoord(v.Coords.x,v.Coords.y,v.Coords.z)
            SetBlipSprite(blip, v.BlipIcon)
            SetBlipColour(blip, v.BlipColor)
            SetBlipScale(blip,0.8)
            SetBlipAsShortRange(blip,true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(v.BlipName)
            EndTextCommandSetBlipName(blip)
        end
    end
end)
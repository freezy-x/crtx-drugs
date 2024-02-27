DebugPrint("Fetching IPL list...")

function loadInterior(coords, interiorProps, interiorsPropColors)
	for k,coords in pairs(coords) do

		local interiorID = GetInteriorAtCoords(coords[1], coords[2], coords[3])

		if IsValidInterior(interiorID) then
			PinInteriorInMemory(interiorID)

			for index,propName in pairs(interiorProps) do
				ActivateInteriorEntitySet(interiorID, propName)
			end

			if interiorsPropColors then
				for i=1, #interiorsPropColors, 1 do
					SetInteriorEntitySetColor(interiorID, interiorsPropColors[i][1], interiorsPropColors[i][2])
				end
			end

			RefreshInterior(interiorID)
		end
	end
end

local iplList = {
	{
        -- Meth Lab
		names = {'bkr_biker_interior_placement_interior_2_biker_dlc_int_ware01_milo'},
		interiorsProps = {
			'meth_lab_security_high',
			'meth_lab_upgrade',
		},
		coords={{1009.5, -3196.6, -38.99682}}
	},

	{
        -- Weed lab
		interiorsProps = {
			'weed_drying',
			'weed_production',
			'weed_upgrade_equip',
			'weed_growtha_stage3',
			'weed_growthc_stage1',
			'weed_growthd_stage1',
			'weed_growthe_stage2',
			'weed_growthf_stage2',
			'weed_growthg_stage1',
			'weed_growthh_stage3',
			'weed_growthi_stage2',
			'weed_hosea',
			'weed_hoseb',
			'weed_hosec',
			'weed_hosed',
			'weed_hosee',
			'weed_hosef',
			'weed_hoseg',
			'weed_hoseh',
			'weed_hosei',
			'light_growtha_stage23_upgrade',
			'light_growthb_stage23_upgrade',
			'light_growthc_stage23_upgrade',
			'light_growthc_stage23_upgrade',
			'light_growthd_stage23_upgrade',
			'light_growthe_stage23_upgrade',
			'light_growthf_stage23_upgrade',
			'light_growthg_stage23_upgrade',
			'light_growthh_stage23_upgrade',
			'light_growthi_stage23_upgrade',
			'weed_security_upgrade',
			'weed_chairs'
		},
		coords={{1051.491, -3196.536, -39.14842}}
	},

	{
        -- Cocaine lab
		interiorsProps = {
			'security_high',
			'equipment_basic',
			'equipment_upgrade',
			'production_upgrade',
			'table_equipment_upgrade',
			'coke_press_upgrade',
			'coke_cut_01',
			'coke_cut_02',
			'coke_cut_03',
			'coke_cut_04',
			'coke_cut_05'
		},
		coords={{1093.6, -3196.6, -38.99841}}
	},


}
DebugPrint("Successfully fetched IPL list!")
Citizen.CreateThread(function()
	for k,ipl in pairs(iplList) do
        DebugPrint("Loading IPL Coords - "..json.encode(ipl.coords).."")
        DebugPrint("Loading IPL Props - "..json.encode(ipl.interiorsProps).."")
		loadInterior(ipl.coords, ipl.interiorsProps, ipl.interiorsPropColors)
	end
end)
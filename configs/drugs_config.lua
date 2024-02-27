freezy = {}
Locale = {}

freezy.Debug = true -- Enable debug prints?
freezy.Locale = 'en' -- Set your locale here
freezy.MinDistance = 200 -- (In GTA Units) How close does the player needs to be before the drug props appear
freezy.AllowProcessingWhenArmed = false -- Allow player to process drugs while having weapons equipped?
freezy.moneyItem = 'money' -- item player gets for selling
freezy.policeJobs = { -- Jobs that will be counted as police job so that players cannot sell without X policemen online
    'police',
    'sheriff',
    'trooper',
    'swat'
}
freezy.EffectDurations = { -- How long should the drug effects last for each drug type
    ['Opium'] = 15000, -- in miliseconds
    ['Weed'] = 15000,
    ['Cocaine'] = 15000,
    ['Meth'] = 15000
}

freezy['Buy'] = {
    {label = "Shovel", name = "shovel", price = 300},
    {label = "Weed Paper", name = "rolling_paper", price = 80},
    {label = "Plastic Bag", name = "empty_bag", price = 100},
    {label = "Canister", name = "empty_canister", price = 200},
}


freezy['Coords'] = {
    Buyers = {
        ['frank'] = {
            coords = vec3(32.6222, -366.1237, 39.3607),
            npc = {ped = 0xE7565327, anim = "WORLD_HUMAN_CLIPBOARD", x = -44.9005, y = -230.783, z = 45.799, h = 67.873016357422},
        },
    },
    Dealers = {
        ['frank'] = {
            coords = vec3(32.6222, -366.1237, 39.3607),
            npc = {ped = 0xE497BBEF, anim = "WORLD_HUMAN_CLIPBOARD", x = 32.6222, y = -366.1237, z = 39.3607, h = 143.4097},
        },
    },
}

freezy.EnableDrugs = { -- You can disable/enable each available drug here
    Weed = true,
    Cocaine = true,
    Meth = true,
    Opium = true,
}

freezy.Drugs = {
    ['Weed Field'] = { -- DO NOT RENAME
        Blip = true,
        BlipName = "Weed Field",
        BlipIcon = 140,
        BlipColor=11,
        Model = "prop_weed_01", -- [prop_weed_01/prop_weed_02] 01 is bigger, 02 is smaller
        Coords = vector3(-2309.0676, 2403.2385, 1.4160), -- Location for gathering the base drug
        NeededItem = { itemName='shovel', label = 'Shovel' },
        MinCount = 1,
        MaxCount = 5,
        AddBlip = true
    },
    ['Weed Production'] = {
        Blip = true,
        BlipName = "Weed Production",
        BlipIcon = 140,
        BlipColor=11,
        Coords = vector3(813.3344, -2398.5488, 23.8067), -- Lab enter (target) location
        NeededWeedForPack = 15, -- How much weed do you need to process it to pack
        NeededWeedForJoint = 5, -- How much weed do you need to process it to joint
        AddBlip = true
    },
    ['Coke Field'] = {
        Blip = true,
        BlipName = "Coke Field",
        BlipIcon = 514,
        BlipColor=25,
        Coords = vector3(2398.8684, 4500.5552, 32.3814), -- Location for gathering the base drug
        NeededItem = { itemName='shovel', label = 'Shovel' },
        MinCount = 1,
        MaxCount = 5,
        AddBlip = true
    },
    ['Coke Production'] = {
        Blip = true,
        BlipName = "Coke Production",
        BlipIcon = 514,
        BlipColor = 11,
        ProcessingTime = {8000,16000}, -- Lab enter (target) location
        Coords = vector3(1211.3468, 1857.5021, 78.9666), -- Location for gathering the base drug
        NeededCokeForBag = 15, -- How much cocaine do you need to process it to pack
        NeededCokeForBrick = 65, -- How much cocaine do you need to process it to brick
        NeededLeafForCoke = 3,
        AddBlip = true
    },
    ['Meth'] = {
        NeededItem = { itemName='empty_canister', label = 'Empty Canister' },
        PickingTime = {6000,12000}, -- Minimum and maximum time
        MinCount = 1,
        MaxCount = 1,
    },
    ['Meth Production'] = {
        Blip = true,
        BlipName = "Meth Production",
        BlipIcon = 499,
        BlipColor=35,
        Coords = vector3(762.9440, -1092.8799, 22.2131), -- Lab enter (target) location
        NeededAcid = 4, -- How much phosporic acid do you need to process it to pure meth
        NeededMeth = 1, -- How much pure meth do you need to process it to bag
    },
    ['Opium Field'] = {
        Blip = true,
        BlipName = "Opium Field",
        BlipIcon = 365,
        BlipColor=25,
        Coords = vector3(1834.8384, 4846.2319, 44.1154-1.4), -- Location for gathering the base drug
        NeededItem = false,
        MinCount = 1,
        MaxCount = 2,
        AddBlip = true
    },

}

freezy.sellingMode = 'manual'  -- [auto/manual] -- With manual mode, you'll need to use the command you set below to be able to sell
freezy.sellingCommand = 'selldrugs' -- Command that will be used with manual mode

freezy.ragdollOnSteal = false -- Drop player on the ground if his drugs gets stolen?
freezy.interactDistance = 3.0 -- Maximum distance player can be away from the NPC to show target options [Bigger number = player can interact from further away]
freezy.npcAgressivityLevel = 2 -- [1 = Only fists | 2 = Can use weapons]
freezy.npcAnimation = "WORLD_HUMAN_DRUG_DEALER" -- [https://pastebin.com/6mrYTdQv] Which animation should the npc use when sale is in progress?
freezy.npcStealMaxSpeed = 5.5 -- [8.0 is normal speed] Maximum speed for the stealing npc while he's running, so the player can still catch him

freezy.allowedNPCWeapons = { -- Weapons NPCs can use when they get angry
    'weapon_pistol',
    'weapon_combatpistol',
    -- 'weapon_machinepistol', -- too overpowered for an npc lol
}

function Dispatch() -- Client side function for police alerts
    local data = {displayCode = '10-14', description = 'Drug Sale', isImportant = 0, recipientList = {'police','lssd','sast'}, length = '10000', infoM = 'fa-cannabis', info = 'A suspicious person has been spotted'}
    local dispatchData = {dispatchData = data, caller = 'Alarm', coords = GetEntityCoords(PlayerPedId())}
    TriggerServerEvent('wf-alerts:svNotify', dispatchData)
end

freezy.Sell = { -- Add as many (drug) items you want
    ["meth_bag"] --[[ Inventory Item Name ]] = {
        label = "Bag of Meth", -- Item Label
        priceRange = {180, 500}, -- Minimum and Maximum sell price
        sellRange = {1, 3}, -- Minimum and Maximum count you can sell
        policeChance = 60, -- Chance to call the police
        stealChance = 10, -- % Chance for the NPC to steal player's drugs
        attackChance = 30, -- % Chance for the NPC to attack the player
        successChance = 60, -- % Chance for successful sell
    },
    ["coke_bag"] = {
        label = "Bag of Cocaine",
        priceRange = {100, 160},
        sellRange = {1, 5},
        policeChance = 60,
        stealChance = 0,
        attackChance = 0,
        successChance = 50,
    },
    ["coke"] = {
        label = "Pure Coke",
        priceRange = {100, 160},
        sellRange = {1, 3},
        policeChance = 60,
        stealChance = 5,
        attackChance = 5,
        successChance = 20,
    },
    ["weed_joint"] = {
        label = "Joint",
        priceRange = {100, 160},
        sellRange = {1, 10},
        policeChance = 60,
        stealChance = 5,
        attackChance = 5,
        successChance = 90,
    },
    ["opium"] = {
        label = "Opium",
        priceRange = {100, 160},
        sellRange = {1, 5},
        policeChance = 60,
        stealChance = 5,
        attackChance = 5,
        successChance = 90,
    },

}


freezy.ignoredPeds = { -- Selling drugs won't be available to these peds
    `mp_m_freemode_01`,
    `mp_f_freemode_01`,
    `mp_m_shopkeep_01`,


    `a_c_boar`,
    `a_c_cat_01`,
    `a_c_chickenhawk`,
    `a_c_cormorant`,
    `a_c_cow`,
    `a_c_deer`,
    `a_c_fish`,
    `a_c_hen`,
    `a_c_husky`,
    `a_c_pig`,
    `a_c_poodle`,
    `a_c_pug`,
    `a_c_retriever`,
    `a_c_rhesus`,
    `a_c_rottweiler`,
    `a_c_sharktiger`,
    `a_c_shepherd`,
    `a_c_stingray`,
    `a_c_westy`,
}
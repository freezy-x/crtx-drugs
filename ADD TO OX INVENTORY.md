# ox_inventory/data/items.lua
```
	['shovel'] = {
		label = 'Shovel',
		weight = 500
	},
	['opium'] = {
		label = 'Opium',
		weight = 15,
		client = {
		export = 'freezy_drugs.opium'
		}
	},
	['empty_canister'] = {
		label = 'Empty Canister',
		weight = 300,
	},
	['rolling_paper'] = {
		label = 'Rolling Paper',
		weight = 5
	},
	['empty_bag'] = {
		label = 'Empty Bag',
		weight = 5
	},
	['coke_leaf'] = {
		label = 'Coke Leaf',
		weight = 3
	},
	['coke_bag'] = {
		label = 'Bag of Cocaine',
		weight = 15,
		client = {
			export = 'freezy_drugs.cocaine'
		}
	},
	['coke_brick'] = {
		label = 'Cocaine Brick',
		weight = 500
	},
	['weed_joint'] = {
		label = 'Joint',
		weight = 10,
		client = {
			export = 'freezy_drugs.weed'
		}
	},
	['weed_leaf'] = {
		label = 'Weed Leaf',
		weight = 5
	},
	['weed_package'] = {
		label = 'Weed Package',
		weight = 80
	},
	['phosphoric_acid'] = {
		label = 'Phosphoric Acid',
		weight = 245
	},
	['pure_meth'] = {
		label = 'Pure Meth',
		weight = 100,
		client = {
			export = 'freezy_drugs.pure_meth'
		}
	},
	['meth_bag'] = {
		label = 'Bag of Methamphetamine',
		weight = 45,
		client = {
			export = 'freezy_drugs.meth'
		}
	},
```

# Also replace your water item with this:
```
	['water'] = {
		label = 'Water',
		weight = 500,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true,
			export = 'freezy_drugs_drugs.stopEffects',
			notification = 'You drank some refreshing water'
		}
	},
```

# Now you're ready to go!
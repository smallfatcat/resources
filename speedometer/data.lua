-- Variables
--------------------------------------------------------------------------

DEBUG_DISPLAY = true
DEBUG_OBJECT = false

limitBottom = 1.0
limitTop = 100.0
timerWaitingToEnd   = false
timerWaitingToStart = false
timerVisible = false
timerRunning = false
speedTimerRunning = false
timerStart   = 0
timerEnd     = 0
timer        = 0

threadFrame  = 0
threadLimit  = 20

vehicles = {0,0,0,0,0}
v1 = vector3(1726.0500488281, 3239.4248046875, 41.545928955078)
v2 = vector3(1726.0500488281, 3244.4248046875, 41.545928955078)
v3 = vector3(1726.0500488281, 3249.4248046875, 41.545928955078)
v4 = vector3(1726.0500488281, 3254.4248046875, 41.545928955078)
v5 = vector3(1726.0500488281, 3259.4248046875, 41.545928955078)
unusedBool, v1ground = GetGroundZFor_3dCoord(v1.x, v1.y, v1.z, 0)
vBank1 = vector3(255.51, 226.60, 101.87)
vBank2 = vector3(-2957.44, 480.30, 15.70)
vBank3 = vector3(-104.17, 6470.57, 31.62)
vBank4 = vector3(1179.65, 2705.01, 38.08)

banks = {vBank1,vBank2,vBank3,vBank4}
--vBank1Door1 = vector3(255.228,223.976,102.393)
bankDoor1 = {pos = vector3(255.228, 223.976, 102.393), closed =  160.0, open = 10.0}
bankDoor2 = {pos = vector3(-2958.538, 482.270, 15.835), closed =  357.542, open = 270.0}
bankDoor3 = {pos = vector3(-104.604, 6473.443, 31.795), closed =  45.0, open = 150.0}
bankDoor4 = {pos = vector3(1175.542, 2710.861, 38.226), closed =  90.0, open = 0.0}

bankDoors = {bankDoor1, bankDoor2, bankDoor3, bankDoor4}
controlPanel1 = vector3(252.916, 228.527, 102.088)
controlPanel2 = vector3(-2956.500, 482.063, 15.897)
controlPanel3 = vector3(-104.604, 6473.443, 31.795)
controlPanel4 = vector3(1175.542, 2710.861, 38.226)
--print("Debug:"..bankDoors[2].open)
carNames = {"jester2","cheetah","zentorno","infernus","comet2", "carbonizzare", "autarch", "bullet", "scramjet", "dodo"}

tpCoords = {
		{name = "Morgue", coords = vector3(275.446, -1361.11, 24.5378)},
		{name = "Pillbox", coords = vector3(291.168,-582.725,43.166)},
    {name = "Michael", coords = vector3(-802.311, 175.056, 72.8446)},
    {name = "Simeon", coords = vector3(-47.16170, -1115.3327, 26.5)},
    {name = "Franklin's aunt", coords = vector3(-9.96562, -1438.54, 31.1015)},
    {name = "Floyd", coords = vector3(-1150.703, -1520.713, 10.633)},
    {name = "TrevorsTrailer", coords = vector3(1985.48132, 3828.76757, 32.5)},
    {name = "ZancudoGates", coords = vector3(-1600.30100000, 2806.73100000, 18.79683000)},
    {name = "UFO.Hippie", coords = vector3(2490.47729, 3774.84351, 2414.035)},
    {name = "UFO.Chiliad", coords = vector3(501.52880000, 5593.86500000, 796.23250000)},
    {name = "UFO.Zancudo", coords = vector3(-2051.99463, 3237.05835, 1456.97021)},
    {name = "RedCarpet", coords = vector3(300.5927, 199.7589, 104.3776)},
    {name = "NorthYankton", coords = vector3(3217.697, -4834.826, 111.8152)},
    {name = "HeistCarrier", coords = vector3(3082.3117, -4717.1191, 15.2622)},
    {name = "HeistYacht", coords = vector3(-2043.974,-1031.582, 11.981)},
    {name = "FinanceOffice1", coords = vector3(-141.1987, -620.913, 168.8205)},
    {name = "BikerCocaine", coords = vector3(1093.6, -3196.6, -38.99841)},
    {name = "BikerCounterfeit", coords = vector3(1121.897, -3195.338, -40.4025)},
    {name = "BikerDocumentForgery", coords = vector3(1165, -3196.6, -39.01306)},
    {name = "BikerMethLab", coords = vector3(1009.5, -3196.6, -38.99682)},
    {name = "BikerWeedFarm", coords = vector3(1051.491, -3196.536, -39.14842)},
    {name = "BikerClubhouse1", coords = vector3(1107.04, -3157.399, -37.51859)},
    {name = "BikerClubhouse2", coords = vector3(998.4809, -3164.711, -38.90733)},
    {name = "ImportVehicleWarehouse", coords = vector3(994.5925, -3002.594, -39.64699)},
    {name = "GunrunningBunker", coords = vector3(892.6384, -3245.8664, -98.2645)},
    {name = "GunrunningYacht", coords = vector3(-1363.724, 6734.108, 2.44598)},
    {name = "SmugglerHangar", coords = vector3(-1267.0, -3013.135, -49.5)},
    {name = "AfterHoursNightclubs", coords = vector3(-1604.664, -3012.583, -78.000)},
    {name = "Doomsday Facility", coords = vector3(83.2006225586, 4810.5405273438, -58.919288635254)},
    {name = "IAA Facility", coords = vector3(2151.1369628906, 2921.3303222656, -61.901874542236)},
    {name = "IAA Server Bank", coords = vector3(2158.1184082032, 2920.9382324218, -81.075386047364)},
    {name = "Avon Hertz Chiliad Bunker", coords = vector3(1259.5418701172, 4812.1196289062, -39.77448272705)},
    {name = "Doomsday Submarine", coords = vector3(514.29266357422, 4885.8706054688, -62.589862823486)},
}

banksObject = {
	{
		id = 1,
		pos = vector3(255.51, 226.60, 101.87),
		name = "Pacific Standard, Vinewood Boulevard",
		state = {
			robbable = true,
			cash = 50000
		},
		doors = { 
			{
				id = 1,
				type = "vault",
				locked = true,
				pos = vector3(255.228, 223.976, 102.393),
				heading_open = 10.0,
				heading_closed = 160.0
			},
			{
				id = 2,
				type = "gate",
				locked = true,
				pos = vector3(262.198, 222.518, 106.429),
				heading_open = 160.0,
				heading_closed = 250.289
			}
		},
		consoles = {
			{
				id = 1,
				pos = vector3(252.916, 228.527, 102.088)
			},
			{
				id = 2,
				pos = vector3(262.218, 223.046, 106.641)
			}
		}
	},
	{
		id = 2,
		pos = vector3(-2957.44, 480.30, 15.70),
		name = "Fleeca Bank, Great Ocean Highway",
		state = {
			robbable = true,
			cash = 50000
		},
		doors = {
			id = 1,
			type = "vault",
			locked = true,
			pos = vector3(-2958.538, 482.270, 15.835),
			heading_open = 270.0,
			heading_closed = 357.542
		},
		consoles = {
			{
				id = 1,
				pos = vector3(-2956.500, 482.063, 15.897)
			},
		}
	},
	{
		id = 3,
		pos = vector3(-104.17, 6470.57, 31.62),
		name = "Blaine County Savings Bank, Paleto Bay",
		state = {
			robbable = true,
			cash = 50000
		},
		doors = {
			id = 1,
			type = "vault",
			locked = true,
			pos = vector3(-104.604, 6473.443, 31.795),
			heading_open = 150.0,
			heading_closed = 45.0
		},
		consoles = {
			{
				id = 1,
				pos = vector3(-105.500, 6471.895, 31.795)
			}
		}
	},
	{
		id = 4,
		pos = vector3(-104.17, 6470.57, 31.62),
		name = "Fleeca Bank, Route 68",
		state = {
			robbable = true,
			cash = 50000
		},
		doors = {
			id = 1,
			type = "vault",
			locked = true,
			pos = vector3(1175.542, 2710.861, 38.226),
			heading_open = 150.0,
			heading_closed = 45.0
		},
		consoles = {
			{
				id = 1,
				pos = vector3(1175.976, 2712.889, 38.226)
			}
		}
	}
}
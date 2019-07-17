banksObject = {
	{
		id = 1,
		pos = vector3(255.51, 226.60, 101.87),
		name = "Pacific Standard, Vinewood Boulevard",
		state = {robbable = true,	cash = 50000},
		doors = { 
			{id = 1, type = "vault", locked = true,	pos = vector3(255.228, 223.976, 102.393),	heading_open = 10.0, heading_closed = 160.0},
			{id = 2, type = "gate",	locked = true, pos = vector3(262.198, 222.518, 106.429), heading_open = 160.0, heading_closed = 250.289},
			{id = 3, type = "gate",	locked = true, pos = vector3(256.311, 220.657, 106.429), heading_open = 50.0, heading_closed = 340.279}
		},
		consoles = {
			{id = 1, pos = vector3(252.916, 228.527, 102.088)},
			{id = 2, pos = vector3(262.218, 223.046, 106.641)}
		},
		locks = {
			{id = 1, pos = vector3(255.228, 223.976, 102.393)},
			{id = 2, pos = vector3(261.789, 221.368, 106.329)},
			{id = 3, pos = vector3(257.460, 220.257, 106.329)},
		}
	},
	{
		id = 2,
		pos = vector3(-2957.44, 480.30, 15.70),
		name = "Fleeca Bank, Great Ocean Highway",
		state = {robbable = true,	cash = 50000},
		doors = {
			{id = 1, type = "vault", locked = true,	pos = vector3(-2958.538, 482.270, 15.835), heading_open = 270.0, heading_closed = 357.542},
		},
		consoles = {
			{id = 1, pos = vector3(-2956.500, 482.063, 15.897)}
		},
		locks = {
			{id = 1, pos = vector3(0.0, 0.0, 0.0)},
		}
	},
	{
		id = 3,
		pos = vector3(-104.17, 6470.57, 31.62),
		name = "Blaine County Savings Bank, Paleto Bay",
		state = {	robbable = true, cash = 50000 },
		doors = {
			{id = 1, type = "vault", locked = true,	pos = vector3(-104.604, 6473.443, 31.795), heading_open = 150.0, heading_closed = 45.0},
		},
		consoles = {
			{id = 1, pos = vector3(-105.500, 6471.895, 31.795)}
		},
		locks = {
			{id = 1, pos = vector3(0.0, 0.0, 0.0)},
		}
	},
	{	
		id = 4, 
		pos = vector3(-104.17, 6470.57, 31.62),
		name = "Fleeca Bank, Route 68",	
		state = {	robbable = true, cash = 50000},
		doors = {
			{id = 1, type = "vault", locked = true,	pos = vector3(1175.542, 2710.861, 38.226), heading_open = 0.0, heading_closed = 90.0},
		},
		consoles = {
			{id = 1,	pos = vector3(1175.976, 2712.889, 38.226)}
		},
		locks = {
			{id = 0, pos = vector3(0.0, 0.0, 0.0)},
		}
	}
}
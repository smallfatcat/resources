--[[bank
	id
	pos
	name
	state
		robbable
		cash
	doors
		id
		type
		locked
		pos
		heading_open
		heading_closed
	consoles
		id
		pos--]]

banks = {
	1 = {
		id = 1,
		pos = vector3(255.51, 226.60, 101.87),
		name = "bank1",
		state = {
			robbable = true,
			cash = 50000
		},
		doors = {
			id = 1,
			type = "vault",
			locked = true,
			pos = vector3(255.228, 223.976, 102.393),
			heading_open = 10.0,
			heading_closed = 160.0
		},
		consoles = {
			id = 1,
			pos = vector3(252.916, 228.527, 102.088)
		}
	},
	2 = {
		id = 2,
		pos = vector3(-2957.44, 480.30, 15.70),
		name = "bank2",
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
			id = 1,
			pos = vector3(-2956.500, 482.063, 15.897)
		}
	}
}
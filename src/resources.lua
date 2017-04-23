resources = {}

function resources:withdraw(credits)
	score = score - credits
end

function resources:deposit(credits)
	score = score + credits
end

function resources:addSatellite(sat_planet, sat_type)
	newSat = {x = 0, y = 0, dir = math.random(0, math.pi * 2), type = sat_type, speed = 6}
	table.insert(sat_planet.assoc_sats, newSat)
end

function resources:addMoon(moon_planet)
	newMoon = {x = 0, y = 0, dir = math.random(0, math.pi * 2), type = "none", speed = -10}
	table.insert(moon_planet.assoc_moons, newMoon)
end
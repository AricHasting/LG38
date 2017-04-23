resources = {}

function resources:withdraw(amount)
	-- decrement the player's credits by amount
	store.credits = store.credits - amount
end

function resources:deposit(amount)
	-- increment the player's credits by amount
	store.credits = store.credits + amount
end

function resources:addSatellite(sat_planet, sat_type)
	-- create a new satellite at the specified planet and decrement the player's credits
	newSat = {x = 0, y = 0, dir = math.random(0, math.pi * 2), type = sat_type, speed = 6}
	table.insert(sat_planet.assoc_sats, newSat)
	if sat_type == "laser" then
		resources:withdraw(store.price_laser)
	else
		resources:withdraw(store.price_shock)
	end
end

function resources:addMoon(moon_planet)
	-- create a new moon at the specified planet and decrement the player's credits
	newMoon = {x = 0, y = 0, rot = 0, dir = math.random(0, math.pi * 2), type = "none", speed = -10}
	table.insert(moon_planet.assoc_moons, newMoon)
	resources:withdraw(store.price_moon)
end

function resources:addRing(ring_planet)
	-- add a ring around the specified planet and decrement the player's credits
	if not ring_planet.ring then
		ring_planet.ring = true
		resources:withdraw(store.price_ring)
	end
end
resources = {}

function resources:withdraw(amount)
	-- decrement the player's credits by amount
	store.credits = store.credits - amount
end

function resources:deposit(amount)
	-- increment the player's credits by amount
	store.credits = store.credits + amount
end

function resources:formatCredits(num)
	return string.format("%05d", num)
end

function resources:addSatellite(sat_planet, sat_type)
	-- create a new satellite at the specified planet and decrement the player's credits
	newSat = {x = 0, y = 0, dir = math.random(0, math.pi * 2), type = sat_type, speed = 6, timer = 0, firerate = 0, nearestEnemy = nil, r = 0, initialPos = true}
	if sat_type == "laser" then
		if store.credits >= store.price_laser then
			newSat.firerate = laserFireRate
			resources:withdraw(store.price_laser)
			table.insert(sat_planet.assoc_sats, newSat)
		end
	else
		if store.credits >= store.price_shock then
			newSat.firerate = shockFireRate
			resources:withdraw(store.price_shock)
			table.insert(sat_planet.assoc_sats, newSat)
		end
	end
end

function resources:addMoon(moon_planet)
	if store.credits >= store.price_moon then
		-- create a new moon at the specified planet and decrement the player's credits
		newMoon = {x = 0, y = 0, rot = 0, dir = math.random(0, math.pi * 2), type = "none", speed = -10}
		table.insert(moon_planet.assoc_moons, newMoon)
		resources:withdraw(store.price_moon)
	end
end

function resources:setMoonType(moon_planet, mtype)
	if mtype == "colony" then
		if store.credits >= store.price_colony and moon_planet.assoc_moons[1].type ~= "colony" then
			moon_planet.assoc_moons[1].type = "colony"
			resources:withdraw(store.price_colony)
		end
	else
		if store.credits >= store.price_lidar and moon_planet.assoc_moons[1].type ~= "lidar" then
			moon_planet.assoc_moons[1].type = "lidar"
			resources:withdraw(store.price_lidar)
		end
	end
end

function resources:addRing(ring_planet)
	if waveOngoing == false then
		-- add a ring around the specified planet and decrement the player's credits
		if not ring_planet.ring then
			ring_planet.ring = true
			resources:withdraw(store.price_ring)
		end
	end
end

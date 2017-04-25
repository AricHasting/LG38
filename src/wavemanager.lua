wavemanager = {}

local wavetimer = 0

function wavemanager:update(dt)
	if waveNumber <= #waves then
		if waveOngoing == true then
			local currentWave = waves[waveNumber]
			wavetimer = wavetimer + dt

			for i, spawner in pairs(currentWave) do
				if spawner.spawnCount > 0 then -- check if it still has enemies to spawn
					--spawner.myTimer = spawner.myTimer + dt -- increment the round timer within the spawner

					if wavetimer > spawner.spawnDelay then -- if the spawner can begin spawning enemies
						spawner.periodTimer = spawner.periodTimer + dt

						if spawner.periodTimer >= spawner.spawnPeriod then -- if it's at the specific interval to spawn an enemy
							enemies:spawn(spawner.spawnType, spawner.spawnPath) -- spawn the enemy
							spawner.spawnCount = spawner.spawnCount - 1
							spawner.periodTimer = 0 -- reset the spawn period timer
						end
					end
				end
			end

			local allSpawned = true
			for i, spawner in pairs(currentWave) do
				if spawner.spawnCount > 0 then
					allSpawned = false
				end
			end

			if allSpawned == true and #activeEnemies == 0 then
				waveOngoing = false
				waveNumber = waveNumber + 1
				resources:deposit(store.round_bonus)

				for i, object in pairs(planet) do
					for j, moonObject in pairs(object.assoc_moons) do
						if moonObject.type == "colony" then
							resources:deposit(store.bonus_colony)
						end
					end
				end
			end
		else
			wavetimer = 0
		end
	end
end

function wavemanager:draw()
	local drawTop = false
	local drawBottom = false
	local drawCenter = false
	if waveNumber <= #waves then
		local currentDrawWave = waves[waveNumber]
		for i, spawner in pairs(currentDrawWave) do
			if spawner.spawnPath == enemyPath.top then
				drawTop = true
			end
			if spawner.spawnPath == enemyPath.bottom then
				drawBottom = true
			end
			if spawner.spawnPath == enemyPath.center then
				drawCenter = true
			end
		end
	end

	if waveOngoing == false then
		if drawTop == true then
			love.graphics.draw(incomingImage, 0, 250, 0, 0.3, 0.3, 0, 97/2)
		end
		if drawBottom == true then
			love.graphics.draw(incomingImage, 0, 1000, 0, 0.3, 0.3, 0, 97/2)
		end
		if drawCenter == true then
			love.graphics.draw(incomingImage, 0, 590, 0, 0.3, 0.3, 0, 97/2)
		end
	end
end
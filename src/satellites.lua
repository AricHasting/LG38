satellites = {}

lg = love.graphics
require "fixcolor"

function satellites:load(args)
		satellitesheet = lg.newImage("assets/satellitesheet.png") -- load satellite sprite sheet into memory
		shockblast = lg.newImage("assets/shockblast.png")
		baseValues:loadSatellites(args)

		shockPulse = love.graphics.newParticleSystem(shockblast, 99999)
		shockPulse:setParticleLifetime(0.5)
		shockPulse:setSizeVariation(0)
	    shockPulse:setSizes(0, 5)
		shockPulse:setColors(255, 255, 255, 100, 255, 255, 255, 0) -- Fade to transparency.
end

function satellites:update(dt)
	-- update each satellite's position
	for i,object in pairs(planet) do
    -- each satellite is nested within a table nested within each planet
        for j, sat in pairs(object.assoc_sats) do

            sat.dir = sat.dir + (((math.pi * 2) / sat.speed) * dt) -- increment the satellite's angle relative to the planet

            -- update the satellite's position based on its orbital position
            sat.x = object.x + angle_utils:lengthdir_x(sat.dir, object.selfOrbit)
            sat.y = object.y + angle_utils:lengthdir_y(sat.dir, object.selfOrbit)

                sat.nearestEnemy = nil
                local k = 1
                while k <= #activeEnemies do
                    local oEnemy = activeEnemies[k]
                    if angle_utils:pointdist(object.x, object.y, oEnemy.x, oEnemy.y) <= object.targetRange then
                        if sat.nearestEnemy ~= nil then
                            if angle_utils:pointdist(sat.x, sat.y, oEnemy.x, oEnemy.y) < angle_utils:pointdist(sat.x, sat.y, sat.nearestEnemy.x, sat.nearestEnemy.y) then
                                sat.nearestEnemy = oEnemy
                            end
                        else
                            sat.nearestEnemy = oEnemy
                        end
                    end

                    k = k + 1
                end
                if sat.nearestEnemy ~= nil and sat.type == "laser" then
										sat.timer = sat.timer + dt
										if sat.timer >= laserFireRate then
                    	sat.nearestEnemy.health = sat.nearestEnemy.health - laserDamage
											sat.timer = 0
										end
										-- rotate towards target enemy
										sat.r = math.rad(math.deg(angle_utils:clampdir(math.atan2(sat.nearestEnemy.x-sat.x, sat.y-sat.nearestEnemy.y))))
										if sat.initialPos then
											sat.initialPos = false
										end
								elseif sat.type == "shock" then
									sat.timer = sat.timer+dt
									if sat.timer >= shockFireRate then
								  	for p,enemyInRange in pairs(activeEnemies) do
								  		if angle_utils:pointdist(enemyInRange.x, enemyInRange.y, object.x, object.y) <= object.targetRange then
												enemyInRange.health = enemyInRange.health - shockDamage
											end
								  	end
										shockPulse:setPosition(object.x, object.y)
										shockPulse:setSizes(0, 4*object.scale)
										shockPulse:emit(1)
										sat.timer = 0
									end
								end
								-- if no enemy has been in sight rotate towards planet
                if sat.initialPos then
									sat.r = sat.dir - math.rad(90)
								end
            end
    end
		shockPulse:update(dt)
end

function satellites:draw()
	lg.draw(shockPulse, 0, 0)
	for i,object in pairs(planet) do
		-- iterate through the satellites contained by each planet and draw it facing its rotation axis
    	for j, sat in pairs(object.assoc_sats) do
            if sat.type == "shock" then
      		    lg.draw(satellitesheet, shockquad, sat.x, sat.y, sat.r, 0.3, 0.3, 255/2, 175)
            elseif sat.type == "laser" then
                if sat.nearestEnemy ~= nil then
										lg.push("all")
                    fixcolor:setColor(109, 207, 246, 170)
                    lg.setLineWidth(5)
                    lg.line(sat.x, sat.y, sat.nearestEnemy.x, sat.nearestEnemy.y)
										lg.pop()
                end
								lg.draw(satellitesheet, laserquad, sat.x, sat.y, sat.r, 0.3, 0.3, 255/2, 175)
            end
    	end
    end
end

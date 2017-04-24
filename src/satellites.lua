satellites = {}

lg = love.graphics
function satellites:load(args)
	satellitesheet = lg.newImage("assets/satellitesheet.png") -- load satellite sprite sheet into memory
    laserquad = lg.newQuad(0, 0, 254, 254, satellitesheet:getDimensions())
    shockquad = lg.newQuad(255, 0, 254, 254, satellitesheet:getDimensions())
    resources:addSatellite(planet.uranus, "shock")
end

function satellites:update(dt)
	-- update each satellite's position
	for i,object in pairs(planet) do
    -- each satellite is nested within a table nested within each planet
        for j, sat in pairs(object.assoc_sats) do

            sat.timer = sat.timer + dt

            sat.dir = sat.dir + (((math.pi * 2) / sat.speed) * dt) -- increment the satellite's angle relative to the planet

            -- update the satellite's position based on its orbital position
            sat.x = object.x + angle_utils:lengthdir_x(sat.dir, object.selfOrbit)
            sat.y = object.y + angle_utils:lengthdir_y(sat.dir, object.selfOrbit)

            if sat.timer >= sat.firerate then
                local nearestEnemy = nil
                local k = 1
                while k <= #activeEnemies do
                    local oEnemy = activeEnemies[k]
                    if angle_utils:pointdist(object.x, object.y, oEnemy.x, oEnemy.y) <= object.targetRange then
                        if nearestEnemy ~= nil then
                            if angle_utils:pointdist(sat.x, sat.y, oEnemy.x, oEnemy.y) < angle_utils:pointdist(sat.x, sat.y, nearestEnemy.x, nearestEnemy.y) then
                                nearestEnemy = oEnemy
                            end
                        else
                            nearestEnemy = oEnemy
                        end
                        if sat.type == "shock" then
                            oEnemy.health = oEnemy.health - shockDamage
                        end
                    end

                    k = k + 1
                end
                sat.timer = 0

                if nearestEnemy ~= nil and sat.type == "laser" then
                    nearestEnemy.health = nearestEnemy.health - laserDamage
                end

                local k = 1
                while k <= #activeEnemies do
                    local oEnemy = activeEnemies[k]
                    if oEnemy.health <= 0 then
                        table.remove(activeEnemies, k)
                    else
                        k = k + 1
                    end
                end
            end
        end
    end
end

function satellites:draw()
	for i,object in pairs(planet) do
		-- iterate through the satellites contained by each planet and draw it facing its rotation axis
    	for j, sat in pairs(object.assoc_sats) do
      		lg.draw(satellitesheet, shockquad, sat.x, sat.y, sat.dir - math.rad(90), 0.3, 0.3, 255/2, 175)
    	end
    end
end

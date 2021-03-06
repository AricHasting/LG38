moons = {}

lg = love.graphics
require "fixcolor"

function moons:update(dt)
	-- update each moon's position
    for i,object in pairs(planet) do
        -- each moon is nested within a table nested within each planet
        for j, moon in pairs(object.assoc_moons) do
            if moon.type == "lidar" then
                object.targetRange = object.baseRange * 1.7
            else
                object.targetRange = object.baseRange
            end

            moon.dir = moon.dir + (((math.pi * 2) / moon.speed) * dt)

            moon.rot = moon.rot - (((math.pi * 2) / 8) * dt)

            moon.x = object.x + angle_utils:lengthdir_x(moon.dir, object.selfOrbit)
            moon.y = object.y + angle_utils:lengthdir_y(moon.dir, object.selfOrbit)
        end
    end
end

function moons:draw()
	for i,object in pairs(planet) do
		-- iterate through the moons contained by each planet and draw it facing its rotation axis
        fixcolor:setColor(255, 255, 255, 255)
    	for j, moon in pairs(object.assoc_moons) do
    	    lg.draw(planetsheet, moonData.quad, moon.x, moon.y, moon.rot, moonData.scale, moonData.scale, 1024 / 2, 1024 / 2)
            if moon.type == "colony" then
                lg.draw(mooncolony, moon.x, moon.y, moon.rot, moonData.scale, moonData.scale, 1491 / 2, 1491 /2)
            end
            if moon.type == "lidar" then
                lg.draw(moonradar, moon.x, moon.y, moon.rot, moonData.scale, moonData.scale, 1491 / 2, 1491 /2)
            end
    	end
    end
end

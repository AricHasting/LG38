moons = {}

lg = love.graphics

function moons:update(dt)
	-- update each moon's position
	for i,object in pairs(planet) do
    -- each moon is nested within a table nested within each planet
    for j, moon in pairs(object.assoc_moons) do
        moon.dir = moon.dir + (((math.pi * 2) / moon.speed) * dt)

        moon.x = object.x + angle_utils:lengthdir_x(moon.dir, object.selfOrbit)
        moon.y = object.y + angle_utils:lengthdir_y(moon.dir, object.selfOrbit)
    end
  end
end

function moons:draw()
	for i,object in pairs(planet) do
		-- iterate through the moons contained by each planet and draw it facing its rotation axis
    	for j, moon in pairs(object.assoc_moons) do
    		lg.setColor(239, 239, 239)
      		lg.circle("fill", moon.x, moon.y, 15)
    	end
    end
end
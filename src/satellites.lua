satellites = {}

lg = love.graphics

function satellites:update(dt)
	-- update each satellite's position
	for i,object in pairs(planet) do
    -- each satellite is nested within a table nested within each planet
    for j, sat in pairs(object.assoc_sats) do
        sat.dir = sat.dir + (((math.pi * 2) / 20) * dt)

        sat.x = object.x + angle_utils:lengthdir_x(sat.dir, object.selfOrbit)
        sat.y = object.y + angle_utils:lengthdir_y(sat.dir, object.selfOrbit)
    end
  end
end

function satellites:draw()
	for i,object in pairs(planet) do
		-- iterate through the satellites contained by each planet and draw it facing its rotation axis
    	for j, sat in pairs(object.assoc_sats) do
      		lg.draw(img, sat.x, sat.y, sat.dir + math.rad(90), 1, 1, 25, 25)
    	end
    end
end
satellites = {}

lg = love.graphics
function satellites:load(args)
	satellitesheet = lg.newImage("assets/satellitesheet.png") -- load satellite sprite sheet into memory
    laserquad = lg.newQuad(0, 0, 254, 254, satellitesheet:getDimensions())
    shockquad = lg.newQuad(255, 0, 254, 254, satellitesheet:getDimensions())
    resources:addSatellite(planet.uranus, "laser")
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

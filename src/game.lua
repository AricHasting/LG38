game = {}

local lg = love.graphics -- bind LG

function game:load(args)
  planetsheet = love.graphics.newImage("assets/planetsheet.png") -- load spriteshet into memory
  planetsheet:setFilter( "linear", "linear", 16 ) -- anisoftropy

  baseValues.loadPlanets(args) -- call after all resources
end

-- only put base values here. Load resources in game:load()
function game:loadBaseValues(args)

end

function game:update(dt)

end

function game:draw()
  lg.push("all")
    lg.setColor(30,30,40)
    lg.rectangle("fill", 0, 0, gameWidth, gameHeight)
    -- draw orbits for each planet
    -- table iterator. Goes through all objects
    for i,object in pairs(planet) do
      if object ~= planet.sun then
        -- sun orbits
        lg.setColor(255,255,255,20)
        love.graphics.setLineWidth( 2 )
        lg.circle("line", planet.sun.x, planet.sun.y, math.sqrt((planet.sun.x-object.x)^2 + (planet.sun.y-object.y)^2)) -- use pythagorean theorem to calculate distance

        -- self orbits
        lg.setColor(255,255,255,50)
        love.graphics.setLineWidth( 5 )
        lg.circle("line", object.x, object.y, object.selfOrbit)
      end
    end
  lg.pop()

  -- draw all the planets. Nothing interesting here. Just usng the coordinates and stuff from the planets table. Offset is 1024/2 (512). Offset uses the raw (unscaled) dimensions
  -- iterate through planet table and draw all planets
  for i,object in pairs(planet) do
    lg.draw(planetsheet, object.quad, object.x, object.y, object.r, object.scale, object.scale, 1024/2, 1024/2) -- draw planets
  end
end

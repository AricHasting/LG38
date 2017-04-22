game = {}

local lg = love.graphics -- bind LG

function game:load(args)
  planetsheet = love.graphics.newImage("assets/planetsheet.png") -- load spriteshet into memory
  img = love.graphics.newImage("assets/satellite.png")
  planetsheet:setFilter( "linear", "linear", 16 ) -- anisoftropy
  love.graphics.setNewFont(20)
  baseValues.loadPlanets(args) -- call after all resources

  local newSat = {dir = 0, x = 100, y = 100}
  table.insert(planet.jupiter.assoc_sats, newSat)
end

function game:update(dt)

  -- bob planets slightly
  for i,object in pairs(planet) do
    if object ~= planet.sun then
      if object.oy+object.y < object.y then
        object.yvel = object.yvel + 100*dt
      elseif object.oy+object.y > object.y then
        object.yvel = object.yvel - 100*dt
      end
      object.oy = object.oy + object.yvel*dt
    end
  end
end

function game:draw()
  lg.push("all")
    lg.setColor(28, 28, 28)
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
    lg.draw(planetsheet, object.quad, object.x, object.y, object.r, object.scale, object.scale, 1024/2, 1024/2+object.oy) -- draw planets
  end
end

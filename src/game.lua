game = {}

local lg = love.graphics -- bind LG

function game:load(args)
  planetsheet = love.graphics.newImage("assets/planetsheet.png") -- load spriteshet into memory
  planetsheet:setFilter( "linear", "linear", 16 ) -- anisoftropy
  devgothicDebug = love.graphics.newFont("assets/devgothic.ttf", 30) -- load Dev Gothic font into memory
  sunGlow = lg.newImage("assets/glow.png")
  viggente = lg.newImage("assets/viggente.png")
  ringsheet = lg.newImage("assets/ringsheet.png")
  score = 0
  selectedPlanet = nil

  love.graphics.setNewFont(20)
  baseValues:loadPlanets(args) -- call after all resources
end

function game:update(dt)

  -- bob planets slightly
  -- iterate through all planets
  for i,object in pairs(planet) do
    if object ~= planet.sun then
      -- move velocity up and down
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
    lg.setColor(255,255,255,255)
    lg.draw(viggente, 0, 0, 0, 1, 1)
    lg.setColor(249, 158, 2, 50)
    lg.draw(sunGlow, planet.sun.x, planet.sun.y, 0, 1.5, 1.5, 1920/2, 1920/2)
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

    if object.ring then
      if object == planet.saturn then
        lg.draw(ringsheet, ring.saturn.quad, object.x, object.y-(object.oy*object.scale), math.rad(-15+object.yvel/60), object.scale, object.scale, 1000, 350/2-80)
      elseif object == planet.uranus then
        lg.draw(ringsheet, ring.uranus.quad, object.x, object.y-(object.oy*object.scale), math.rad(20+object.yvel/70), object.scale, object.scale, 1000, 351/2-80)
      end
    end
  end
end

game = {}

local lg = love.graphics -- bind LG

function game:load(args)
  planetsheet = love.graphics.newImage("assets/planetsheet.png") -- load spriteshet into memory
  planetsheetData = love.image.newImageData("assets/planetsheet.png") -- load image data into memory
  planetsheet:setFilter( "linear", "linear", 16 ) -- anisoftropy
  sunGlow = lg.newImage("assets/glow.png")
  viggente = lg.newImage("assets/viggente.png")
  ringsheet = lg.newImage("assets/ringsheet.png")
  mooncolony = lg.newImage("assets/moon_colony_overlay.png")
  moonradar = lg.newImage("assets/moon_radar_overlay.png")
  incomingImage = lg.newImage("assets/incoming.png")
  satellitesheet = lg.newImage("assets/satellitesheet.png") -- load satellite sprite sheet into memory
  shockblast = lg.newImage("assets/shockblast.png")

  baseValues:loadStore(args)
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

      -- fix objects planets floating offscreen on focus lost by clamping velocities
      if object.yvel >= 100 then
        object.yvel = 100
      elseif object.yvel <= -100 then
        object.yvel = -100
      end
    end
  end

  if planet.earth.health <= 0 then
    planet.earth.scale = 0
    psystemExplode:setPosition(planet.earth.x, planet.earth.y)
    psystemExplode:emit(1000)
    gamestate = "lost"
  end
end

local ssm = 1 -- planet scale local
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
        -- if planet selected recolor the sun
        lg.setColor(255,255,255,20)
        if selectedPlanet == object then
          lg.setColor(100,255,100,50)
        end
        love.graphics.setLineWidth( 2 )
        lg.circle("line", planet.sun.x, planet.sun.y, math.sqrt((planet.sun.x-object.x)^2 + (planet.sun.y-object.y)^2)) -- use pythagorean theorem to calculate distance

        -- self orbits
        -- if the planet is selected recolor the orbit
        lg.setColor(255,255,255,50)
        if selectedPlanet == object then
          lg.setColor(100,255,100,50)
        end
        love.graphics.setLineWidth( 5 )
        lg.circle("line", object.x, object.y, object.selfOrbit)
      end
    end
  lg.pop()

  -- draw all the planets. Nothing interesting here. Just usng the coordinates and stuff from the planets table. Offset is 1024/2 (512). Offset uses the raw (unscaled) dimensions
  -- iterate through planet table and draw all planets
  for i,object in pairs(planet) do

    -- check if planet selected. If so upscale the drawable
    if object == selectedPlanet then
      ssm = 1.2
    else
      ssm = 1
    end

    lg.draw(planetsheet, object.quad, object.x, object.y, object.r, object.scale*ssm, object.scale*ssm, 1024/2, 1024/2+object.oy) -- draw planets

    -- draw rings on the planets
    if object.ring then
      -- special cases for saturn and uranus
      if object == planet.saturn then
        lg.draw(ringsheet, ring.saturn.quad, object.x, object.y-(object.oy*object.scale), math.rad(-15+object.yvel/60), object.scale*ssm, object.scale*ssm, 1000, 350/2-80)
      elseif object == planet.uranus then
        lg.draw(ringsheet, ring.uranus.quad, object.x, object.y-(object.oy*object.scale), math.rad(20+object.yvel/70), object.scale*ssm, object.scale*ssm, 1000, 351/2-80)
      else
        lg.push("all")
        lg.setColor(object.color)
        -- draw ring. Offsets based on the bob animation. The rotation angle is also based on it.
        lg.draw(ringsheet, ring.normal.quad, object.x, object.y-(object.oy*object.scale), math.rad(object.yvel/60), object.scale*ssm, object.scale*ssm, 1000, 350/2-80)
        lg.pop()
      end
    end
  end
end

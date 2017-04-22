enemies = {}
local lg = love.graphics

function enemies:load(args)
  enemysheet = lg.newImage("assets/enemysheet.png") -- load assets into memory
  baseValues:loadEnemies(args) -- call after all resources

  --[[
  for i=1,10000 do
  local newEnemy = {
    quad = enemy.normal.quad,
    x = 0,
    y = love.math.random(0, 1080),
    target = planet.saturn,
    xvel = love.math.random(20, 200),
    yvel = love.math.random(-100, 100),
    r = 0,
    scale = enemy.normal.scale
   }
  table.insert(activeEnemies, newEnemy)
  end ]]
end

function enemies:update(dt)
  -- iterate through both enemy and planet table and update all enemies
  for i,objEnemy in pairs(activeEnemies) do
    for m,objPlanet in pairs(planet) do
        if math.sqrt((objEnemy.x-objPlanet.x)^2 + (objEnemy.y-objPlanet.y)^2) <= objPlanet.gravity then

          -- dumb hack to not prefer sun gravity when in a planet's gravity
          if objPlanet ~= planet.sun then
            gravityPull(objPlanet, objEnemy, dt)
          elseif objPlanet == planet.sun then
            gravityPull(objPlanet, objEnemy, dt)
          end
        end
    end
    -- move player based on velocity
    objEnemy.x = objEnemy.x + objEnemy.xvel*dt
    objEnemy.y = objEnemy.y + objEnemy.yvel*dt

    -- rotate player based on velocity
    local angle = math.atan2((objEnemy.x+objEnemy.xvel)-objEnemy.x, objEnemy.y-(objEnemy.y+objEnemy.yvel)) -- calculate angle between enemy and theoretical future movement
    if angle < 0 then
      angle = angle + 2* math.pi -- normalize angle
    end
    objEnemy.r = math.deg(angle) -- turn angle to degrees
  end

  -- manually sets everything so we can delete while running through the table
  local i = 1
  -- manual iterator. Removing stuff from a normal one will cause everything to spaz. We dont want that.
	while i <= #activeEnemies do
    local object = activeEnemies[i]
    --remove if offscreen. If we remove we skip iterating that frame
    if object.x > gameWidth+200 or object.x <-200 or object.y > gameHeight+200 or object.y < -200 then
      table.remove(activeEnemies, i)
    else
      i = i+1 -- if we don't remove we iterate
    end
  end
end

-- offset to a different function because dumb hack
function gravityPull(objPlanet, objEnemy, dt)
  -- nothing special, depending on which side of the planet we are we reduce or increase velocity so that it "falls" towards it.
  if objEnemy.y > objPlanet.y then
    objEnemy.yvel = objEnemy.yvel-objPlanet.pull*dt
  end
  if objEnemy.y < objPlanet.y then
    objEnemy.yvel = objEnemy.yvel+objPlanet.pull*dt
  end
  if objEnemy.x > objPlanet.x then
    objEnemy.xvel = objEnemy.xvel-objPlanet.pull*dt
  end
  if objEnemy.x < objPlanet.x then
    objEnemy.xvel = objEnemy.xvel+objPlanet.pull*dt
  end
end

function enemies:draw()
  -- iterate through table and draw all enemies
  for i,object in pairs(activeEnemies) do
    lg.draw(enemysheet, object.quad, object.x, object.y, math.rad(object.r), object.scale, object.scale, 1024/2, 1024/2)
  end
end

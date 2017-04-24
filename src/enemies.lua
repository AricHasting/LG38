enemies = {}
local lg = love.graphics

function enemies:load(args)
  enemysheet = lg.newImage("assets/enemysheet.png") -- load assets into memory
  baseValues:loadEnemies(args) -- call after all resources

end

function enemies:update(dt)

  -- iterate through both enemy and planet table and update all enemies
  for i,objEnemy in pairs(activeEnemies) do

    objEnemy.x = objEnemy.x + math.sin(math.rad(objEnemy.r))*dt*objEnemy.speed
		objEnemy.y = objEnemy.y - math.cos(math.rad(objEnemy.r))*dt*objEnemy.speed

    -- top path
    if objEnemy.path == enemyPath.top then
      self:checkPoints(enemyPath.top, objEnemy)
    --center path
    elseif objEnemy.path == enemyPath.center then
      self:checkPoints(enemyPath.center, objEnemy)
    --bottom path
    elseif objEnemy.path == enemyPath.bottom then
      self:checkPoints(enemyPath.bottom, objEnemy)
    end
    -- this path affects everyone
    self:checkPoints(enemyPath.all, objEnemy)

    if angle_utils:pointdist(objEnemy.x, objEnemy.y, planet.earth.x, planet.earth.y) <= planet.earth.gravity then
      planet.earth.health = planet.earth.health-objEnemy.damage*dt
    end
  end

  -- manual iterator. Removing stuff from a normal one will cause everything to spaz. We dont want that.
  local i = 1
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

function enemies:checkPoints(path, objEnemy)
  for n,objSwitcher in pairs(path) do
    -- go through all the path points and check if we're touching it. If yes, set our angle to the one in the point
    if angle_utils:pointdist(objEnemy.x, objEnemy.y, objSwitcher.x, objSwitcher.y) <= objSwitcher.radius then
      objEnemy.r = objSwitcher.r
    end
  end
end

function enemies:spawn(type, path)
  local newEnemy = {
    quad = type.quad,
    x = 0,
    y = 0, -- TOP 250; CENTER 590; BOTTOM 1000
    r = 0, -- TOP 110; CENTER 70; BOTTOM 50
    speed = type.speed,
    scale = type.scale,
    damage = type.damage,
    path = path
  }
  -- change spawn locations based on height
  if path == enemyPath.top then
    newEnemy.y = 250
    newEnemy.r = 110
  elseif path == enemyPath.center then
    newEnemy.y = 590
    newEnemy.r = 70
  elseif path == enemyPath.bottom then
    newEnemy.y = 1000
    newEnemy.r = 50
  end
  -- push enemy to table
  table.insert(activeEnemies, newEnemy)
end

function enemies:draw()
  -- iterate through table and draw all enemies
  for i,object in pairs(activeEnemies) do
    lg.draw(enemysheet, object.quad, object.x, object.y, math.rad(object.r), object.scale, object.scale, 1024/2, 1024/2)
    
    -- draw enemy laser
    if angle_utils:pointdist(object.x, object.y, planet.earth.x, planet.earth.y) <= planet.earth.gravity then
      lg.push("all")
      lg.setLineWidth(5)
      lg.setColor(255,255,0,100)
      lg.line(object.x, object.y, planet.earth.x, planet.earth.y)
      lg.pop()
    end
  end
end

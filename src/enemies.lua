enemies = {}
local lg = love.graphics

function enemies:load(args)
  enemysheet = lg.newImage("assets/enemysheet.png") -- load assets into memory
  baseValues:loadEnemies(args) -- call after all resources

  local newEnemy = {
    quad = enemy.normal.quad,
    x = 0,
    y = 300,
    r = 0,
    speed = 200,
    scale = enemy.normal.scale
  }
  table.insert(activeEnemies, newEnemy)
end

function enemies:update(dt)

  -- iterate through both enemy and planet table and update all enemies
  for i,objEnemy in pairs(activeEnemies) do

    objEnemy.x = objEnemy.x+objEnemy.speed*dt

    for m,objPlanet in pairs(planet) do
        if math.sqrt((objEnemy.x-objPlanet.x)^2 + (objEnemy.y-objPlanet.y)^2) <= objPlanet.gravity+512*objEnemy.scale then

        end
    end
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

function enemies:draw()
  -- iterate through table and draw all enemies
  for i,object in pairs(activeEnemies) do
    lg.draw(enemysheet, object.quad, object.x, object.y, math.rad(object.r), object.scale, object.scale, 1024/2, 1024/2)
  end
end

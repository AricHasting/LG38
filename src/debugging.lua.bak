debugging = {}
local lg = love.graphics

function debugging:update(dt)

end

function debugging:keypressed(key, scancode, isrepeat)
  -- escape stops the game
  if key == "escape" then
      love.event.quit()
  elseif key == "space" then
    enemies:spawn(100, enemy.normal, 1080-400, -100)
  end
end

function debugging:draw()
  -- draw planet's gravitation fields
  for i,object in pairs(planet) do
      lg.push("all")
      lg.setColor(255,0,0,20)
      lg.circle("fill", object.x, object.y, object.gravity)
      lg.pop()
  end

  lg.print("DEBUGGING MODE (TAB TOGGLE)", 10, 10)
end

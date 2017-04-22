debugging = {}

function debugging:update(dt)

end

function debugging:keypressed(key, scancode, isrepeat)
  -- escape stops the game
  if key == "escape" then
      love.event.quit()
  end
end

function debugging:draw()

end

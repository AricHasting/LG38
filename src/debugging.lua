debugging = {}
local lg = love.graphics

function debugging:update(dt)

end

--local newPath = nil
--local pathSelected = {}
function debugging:keypressed(key, scancode, isrepeat)
  -- q stops the game
  if key == "q" then
    love.event.quit()
  elseif key == "m" then
    musicSelected:setVolume(0)
  elseif key == "space" then
    enemies:spawn(enemy.normal, enemyPath.top)
    enemies:spawn(enemy.medium, enemyPath.center)
    enemies:spawn(enemy.hard, enemyPath.bottom)
  elseif key == "s" then
    waveOngoing = true
  end

  --elseif key == "p" then
    --love.system.setClipboardText(table.tostring(pathSelected))

--[[
  if key == "z" then
    if newPath == nil then
      pathSelected = enemyPath.all
      newPath = {}
      local mx, my = push:toGame(love.mouse.getPosition())
      newPath = {
        x = mx,
        y = my,
        r = 0,
        radius = 25
      }
    else
      local mx, my = push:toGame(love.mouse.getPosition())
      local angle = math.atan2(mx-newPath.x, newPath.y-my) -- calculate angle between vertical pane and mouse
      if angle < 0 then
        angle = angle + 2* math.pi -- normalize angle
      end
      angle = math.deg(angle) -- convert angle to degrees
      newPath.r = angle
      table.insert(pathSelected, newPath)
      newPath = nil
    end
  end
  if key == "backspace" then
    table.remove(pathSelected, #pathSelected)
  end]]
end

function debugging:draw()
  -- draw planet's gravitation fields
  for i,object in pairs(planet) do
      lg.push("all")
      lg.setColor(255,0,0,20)
      lg.circle("fill", object.x, object.y, object.gravity)
      lg.setColor(0, 255, 0, 20)
      lg.circle("fill", object.x, object.y, object.targetRange)
      lg.pop()
  end

  lg.setFont(devgothicDebug)
  lg.setColor(255, 255, 255, 255)
  lg.print("DEBUGGING MODE (TAB TOGGLE)", 10, 20)
  lg.print("Press Q to quit", 10, 40)
  if selectedPlanet ~= nil then
    lg.print(selectedPlanet.name, 10, 70)
  end

  --[[
  for i,object in pairs(pathSelected) do
    lg.circle("fill", object.x, object.y, object.radius)
    lg.draw(enemysheet, enemy.medium.quad, object.x, object.y, math.rad(object.r), enemy.medium.scale, enemy.medium.scale, 512, 512)
  end

  if newPath ~= nil then
    local mx, my = push:toGame(love.mouse.getPosition())
    lg.line(newPath.x, newPath.y, mx, my)
  end ]]
end
--[[
function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end ]]

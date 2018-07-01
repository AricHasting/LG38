menu = {}
local lg = love.graphics
require "fixcolor"

function menu:load(args)
  fontTitle = love.graphics.newFont("assets/devgothic.ttf", 100) -- load Dev Gothic font into memory
  titleImage = love.graphics.newImage("assets/title.png")
  --music_slider = {value = 1, max = 1, min = 0}
  --fx_slider = {value = 1, max = 1, min = 0}
end

function menu:drawPause(args)
  lg.push("all")
  fixcolor:setColor(0,0,0,150)
  lg.rectangle("fill", 0, 0, gameWidth, gameHeight) -- darken the screen when we pause
  fixcolor:setColor(255,255,255)
  lg.setFont(fontTitle)
  lg.printf("PAUSED", 0, 0, gameWidth, "center") -- center the paused text
  lg.pop()
end

function menu:drawLost()
  lg.push("all")
  fixcolor:setColor(0,0,0,200)
  lg.rectangle("fill", 0, 0, gameWidth, gameHeight) -- darken the screen when we pause
  fixcolor:setColor(255,255,255)
  lg.setFont(fontTitle)
  lg.printf("You could not save the world!", 0, gameHeight/2-50, gameWidth, "center") -- center the paused text
  lg.setFont(devgothicTopRight)
  lg.printf("press [R] to restart", 0, gameHeight/2+50, gameWidth, "center")
  lg.printf("press [esc] to go to menu", 0, gameHeight/2+100, gameWidth, "center")
  lg.pop()
end

local z1 = {73, 104, 174, 200}
local z2 = {73, 104, 174, 200}
function menu:updateMenu(dt)
  if planet.jupiter.oy+planet.jupiter.y < planet.jupiter.y then
    planet.jupiter.yvel = planet.jupiter.yvel + 100*dt
  elseif planet.jupiter.oy+planet.jupiter.y > planet.jupiter.y then
    planet.jupiter.yvel = planet.jupiter.yvel - 100*dt
  end
  planet.jupiter.oy = planet.jupiter.oy + planet.jupiter.yvel*dt

  -- fix planet.jupiters planets floating offscreen on focus lost by clamping velocities
  if planet.jupiter.yvel >= 100 then
    planet.jupiter.yvel = 100
  elseif planet.jupiter.yvel <= -100 then
    planet.jupiter.yvel = -100
  end

  local mx, my = push:toGame(love.mouse.getPosition())

  if mx ~= nil and my ~= nil then
    if mx >= gameWidth/2-gameWidth/3/2 and mx <= gameWidth/2-gameWidth/3/2+gameWidth/3 and my >=600 and my <= 800 then
      z1 = {200, 104, 174, 200}
    elseif mx >= gameWidth/2-gameWidth/3/2 and mx <= gameWidth/2-gameWidth/3/2+gameWidth/3 and my >=850 and my <= 1050 then
      z2 = {200, 104, 174, 200}
    else
      z1 = {73, 104, 174, 200}
      z2 = {73, 104, 174, 200}
    end
  end
end

function menu:drawMenu()
  lg.push("all")
    fixcolor:setColor(28, 28, 28)
    lg.rectangle("fill", 0, 0, gameWidth, gameHeight)
    fixcolor:setColor(255,255,255,255)
    lg.draw(viggente, 0, 0, 0, 1, 1)
    lg.draw(planetsheet, planet.jupiter.quad, gameWidth/2, gameHeight/2, 0, 0.5, 0.5, 1024/2, 1024/2+planet.jupiter.oy)
    fixcolor:setColor(0, 0, 0, 0)
    lg.rectangle("fill", 0, 0, gameWidth, gameHeight)
    fixcolor:setColor(z1)
    lg.rectangle("fill", gameWidth/2-gameWidth/3/2, 600, gameWidth/3, 200, 100)
    fixcolor:setColor(z2)
    lg.rectangle("fill", gameWidth/2-gameWidth/3/2, 850, gameWidth/3, 200, 100)
    fixcolor:setColor(255,255,255,200)
    lg.setFont(fontTitle)
    lg.printf("Play", 0, 650, gameWidth, "center")
    lg.printf("Quit", 0, 900, gameWidth, "center")
    lg.draw(titleImage, 200, 10)
    lg.setFont(devgothicTopRight)
    lg.print("Coding by", 10, 900)
    lg.print("Rukinom and Nexrem", 10, 950)
    lg.print("Art by", 1500, 900)
    lg.print("AssaultCommand", 1500, 950)
    lg.print("Music by", 1500, 800-50)
    lg.print("Neon Mitsumi", 1500, 850-50)
  lg.pop()
end

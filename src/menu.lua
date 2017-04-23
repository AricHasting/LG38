menu = {}
local lg = love.graphics

function menu:load(args)
  fontTitle = love.graphics.newFont("assets/devgothic.ttf", 100) -- load Dev Gothic font into memory\
  music_slider = {value = 1, max = 1, min = 0}
  fx_slider = {value = 1, max = 1, min = 0}
end

function menu:drawPause(args)
  lg.push("all")
  lg.setColor(0,0,0,150)
  lg.rectangle("fill", 0, 0, gameWidth, gameHeight) -- darken the screen when we pause
  lg.setColor(255,255,255)
  lg.setFont(fontTitle)
  lg.printf("PAUSED", 0, 0, gameWidth, "center") -- center the paused text
  lg.pop()
end
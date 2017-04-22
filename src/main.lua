require "game"
require "baseValues"
require "debugging"
require "angle_utils"
require "satellites"
push = require "lib.push"

gameWidth, gameHeight = 1920, 1080 --fixed game resolution no chango amigo!
local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth*.7, windowHeight*.7 --make the window a bit smaller than the screen itself
push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, resizable = true}) -- start push service for letterboxing.

debug = true
gamestate = "game" -- state switcher

function love.load(args)
	game:load(args)
end


function love.update(dt)
	-- only update if in game state
	if gamestate == "game" then
		game:update(dt)
	end

	-- debugging
	if debug then
		debugging:update(dt)
	end
end


function love.draw()
	push:start() -- start letterboxing

		-- only draw if in game or pause state
		if gamestate == "game" or gamestate == "pause" then
			game:draw()
		end

		-- debugging
		if debug then
			debugging:draw()
		end

	push:finish() --stop letterboxing
end

-- when the window gets resized this function fires. Use to fix up letterboxing
function love.resize(w, h)
  push:resize(w, h)
end

-- event when key goes down.
function love.keypressed(key, scancode, isrepeat)
	if debug then
		debugging:keypressed(key, scancode, isrepeat)
	end
end

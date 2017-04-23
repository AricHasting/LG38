require "game"
require "baseValues"
require "debugging"
require "angle_utils"
require "satellites"
require "enemies"
require "moons"
require "uimanager"
push = require "lib.push"

gameWidth, gameHeight = 1920, 1080 --fixed game resolution no chango amigo!
local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth*.7, windowHeight*.7 --make the window a bit smaller than the screen itself
push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, resizable = true}) -- start push service for letterboxing.

debug = true
gamestate = "game" -- state switcher

function love.load(args)
	game:load(args)
	enemies:load(args)
	satellites:load(args)
end


function love.update(dt)
	-- only update if in game state
	if gamestate == "game" then
		game:update(dt)
		enemies:update(dt)
		satellites:update(dt)
		moons:update(dt)
		uimanager:update(dt)
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
			enemies:draw()
			satellites:draw()
			moons:draw()
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

-- event when a mouse button is pressed
function love.mousepressed(x, y, button, istouch)
	uimanager:mousepressed(x, y, button, istouch)
end

-- event when key goes down.
function love.keypressed(key, scancode, isrepeat)
	if debug then
		debugging:keypressed(key, scancode, isrepeat)
	end
	if key == "tab" then
		debug = not debug
	end
end

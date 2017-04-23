require "game"
require "baseValues"
require "debugging"
require "angle_utils"
require "satellites"
require "enemies"
require "moons"
require "menu"
require "uimanager"
require "resources"
push = require "lib.push"

gameWidth, gameHeight = 1920, 1080 --fixed game resolution no chango amigo!
local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth*.7, windowHeight*.7 --make the window a bit smaller than the screen itself
push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, resizable = true}) -- start push service for letterboxing.

function love.load(args)
	devgothicDebug = love.graphics.newFont("assets/devgothic.ttf", 30) -- load Dev Gothic font into memory

	baseValues:loadGame(args)
	game:load(args)
	enemies:load(args)
	satellites:load(args)
	menu:load(args)
end


function love.update(dt)
	-- only update if in game state
	if gamestate == "game" then
		game:update(dt)
		enemies:update(dt)
		satellites:update(dt)
		moons:update(dt)
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
		if gamestate == "pause" then
			menu:drawPause()
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
	uimanager:keypressed(key, scancode, isrepeat)
end

function love.focus(hasFocus)
  if not hasFocus and gamestate ~= "pause" then
		gamestate = "pause"
	end
end

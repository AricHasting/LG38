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
require "wavemanager"
push = require "lib.push"

debug = false
gamestate = "menu" -- state switcher

gameWidth, gameHeight = 1920, 1080 --fixed game resolution no chango amigo!
local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth*.7, windowHeight*.7 --make the window a bit smaller than the screen itself
push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, resizable = true}) -- start push service for letterboxing.

function love.load(args)
	devgothicDebug = love.graphics.newFont("assets/devgothic.ttf", 30) -- load Dev Gothic font into memory for debug
	devgothicTopRight = love.graphics.newFont("assets/devgothic.ttf", 60) -- load font for top right UI
	devgothicStoreMenu = love.graphics.newFont("assets/devgothic.ttf", 15) -- load font for top right UI

	-- load both music files
	music1 = love.audio.newSource("assets/stars.mp3", "stream")
	music2 = love.audio.newSource("assets/rings.mp3", "stream")

	-- make both music sources loop
	music1:setLooping(true)
	music2:setLooping(true)

	if gamestate == "game" then
		musicSelected = music2
	else
		musicSelected = music1
	end

	baseValues:loadGame(args)
	game:load(args)
	enemies:load(args)
	satellites:load(args)
	menu:load(args)
	uimanager:load(args)
end


function love.update(dt)
	-- only update if in game state
	if gamestate == "game" then
		game:update(dt)
		wavemanager:update(dt)
		enemies:update(dt)
		satellites:update(dt)
		moons:update(dt)
		uimanager:update(dt)
		-- do this check to avoid calling it all the time
		-- if gamestate game then normal speed and volume
		if musicSelected:getPitch() ~= 1 then
			musicSelected:setPitch(1)
			musicSelected:setVolume(0.1)
		end

	end

	if gamestate == "pause" or gamestate == "lost" then
		-- do this check to avoid calling it all the time
		-- if gamestate game then low speed and volume
		if musicSelected:getPitch() ~= 0.5 then
			musicSelected:setPitch(0.5)
			musicSelected:setVolume(0.02)
		end

		psystemExplode:update(dt)
	end

	if gamestate == "menu" then
		menu:updateMenu(dt)
	end

	-- debugging
	--[[if debug then
		debugging:update(dt)
	end]]
end


function love.draw()
	push:start() -- start letterboxing

		-- only draw if in game or pause state
		if gamestate == "game" or gamestate == "pause" or gamestate == "lost" then
			game:draw()
			enemies:draw()
			satellites:draw()
			moons:draw()
			uimanager:draw()
			wavemanager:draw()
		end
		if gamestate == "pause" then
			menu:drawPause()
		end
		if gamestate == "lost" then
			menu:drawLost()
		end

		if gamestate == "menu" then
			menu:drawMenu()
		end

		-- debugging
		--[[if debug then
			debugging:draw()
		end]]

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
  -- automatically pause the game when it loses focus
  if not hasFocus and gamestate == "game" then
		gamestate = "pause"
	end
end

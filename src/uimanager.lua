uimanager = {}

lg = love.graphics

function uimanager:load( args )
	earthIcon = lg.newImage("assets/earth_cutout.png")
	creditIcon = lg.newImage("assets/credits.png")
	earthIcon:setFilter("linear", "linear", 16) -- anisoftropy
	creditIcon:setFilter("linear", "linear", 16)

	healthbarShine = {
		img = lg.newImage("assets/healthbarShine.png"),
		x = 1920,
		y = 0,
		a = 255
	}
end

function uimanager:mousepressed(x, y, button, istouch)
	local x, y = push:toGame(x, y) -- transform coords to game from letterbox value
	local newPlanet = false
	-- only be able to select while game running (not paused)
	if gamestate == "game" then
		-- for each planet besides the sun
		for i, object in pairs(planet) do
			if object ~= planet.sun then
				-- check if within gravity area using distance between two points
				if angle_utils:pointdist(x, y, object.x, object.y) <= object.gravity and selectedPlanet ~= object then
					newPlanet = true
					selectedPlanet = object -- select the planet
					break -- break the iterator when we select
				-- if mouse not over a planet and something is selected then deselect it
				end
				if newPlanet == false and selectedPlanet ~= nil then
					selectedPlanet = nil
				end
			end
		end
	end
end

function uimanager:keypressed(key, scancode, isrepeat)
	if key == "tab" then
		debug = not debug
	elseif key == "escape" then
		-- escape key pauses game
		if gamestate == "pause" then
			gamestate = "game"
		elseif gamestate == "game" then
			gamestate = "pause"
		end
	end
end

function uimanager:update(dt)
	healthbarShine.x = healthbarShine.x-400*dt
	if healthbarShine.x <= 400 then
		healthbarShine.x = 1920
		healthbarShine.a = 255
	end
	healthbarShine.a = healthbarShine.a - 80*dt*(100/planet.earth.health)
end

function uimanager:draw()
	lg.push("all")
	lg.setColor(0,0,0)
	lg.polygon("fill", 455,58, 414,0, 1495,0, 1495,58)
		-- health bar
	lg.setColor(58, 173, 70,255)
	lg.polygon("fill", 414+(1080/100*(100-planet.earth.health)),0, 455+(1080/100*(100-planet.earth.health)),58, 1494,58, 1494,0)
	lg.setColor(255,255,255,healthbarShine.a)
	lg.draw(healthbarShine.img, healthbarShine.x, healthbarShine.y)
	lg.setColor(73, 104, 174, 255)
	lg.setLineWidth(10)
	lg.setLineJoin( "miter" )
	lg.line(419,5, 1505,5)
	lg.line(414,-5, 455,58)
	lg.line(453,58, 1505,58)
	lg.polygon("fill", 1442,0, 1546,104, 1920,104, 1920,0)
	lg.setColor(255, 255, 255, 255)
	lg.draw(earthIcon, 1587, 52, 0, 0.05, 0.05, 1025 / 2, 1025 / 2)
	lg.draw(creditIcon, 1761, 52, 0, 0.05, 0.05, 1025 / 2, 1025 / 2)
	lg.setFont(devgothicTopRight)
	lg.print(math.floor(planet.earth.health) .. "%", 1629, 26)
	lg.print(store.credits, 1775, 26)
	lg.pop()
end

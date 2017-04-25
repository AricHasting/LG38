uimanager = {}

lg = love.graphics

function uimanager:load( args )
	earthIcon = lg.newImage("assets/earth_cutout.png")
	creditIcon = lg.newImage("assets/credits.png")
	runIcon = lg.newImage("assets/next_wave_button.png")
	earthIcon:setFilter("linear", "linear", 16) -- anisoftropy
	creditIcon:setFilter("linear", "linear", 16)
	runIcon:setFilter("linear", "linear", 16)

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

		if x >= 1825 and y <= 104 then
			gamestate = "pause"
		end

		if y >= 975 and x <= 122 then
			waveOngoing = true
		end

	elseif gamestate == "pause" then
		gamestate = "game"
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
		elseif gamestate == "lost" then
			gamestate = "menu"
			musicSelected = music1
			baseValues:loadGame()
		end
	end

	if key == "r" and gamestate == "lost" then
		baseValues:loadAll()
		gamestate = "game"
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
	lg.draw(creditIcon, 1620, 52, 0, 0.05, 0.05, 1025 / 2, 1025 / 2)
	lg.setFont(devgothicTopRight)
	lg.print(resources:formatCredits(store.credits), 1630, 21)

	lg.setColor(173, 150, 59, 255)
	lg.rectangle("fill", 1825, 0, 95, 104)

	lg.setColor(255, 255, 255, 255)
	lg.rectangle("fill", 1855, 30, 10, 45)
	lg.rectangle("fill", 1880, 30, 10, 45)

	if waveOngoing == false then
		lg.setColor(158, 11, 15, 255)
		lg.polygon("fill", 0, 975, 81, 975, 122, 1017, 122, 1079, 0, 1079)

		lg.setColor(255, 255, 255, 255)
		lg.draw(runIcon, 30, 1005, 0, .044, .044, 0, 0)
	end

	if selectedPlanet ~= nil then
		lg.setColor(20, 72, 149, 100)
		lg.rectangle("fill", selectedPlanet.x + 100, selectedPlanet.y - 150, 200, 300)

		lg.setColor(255, 255, 255, 255)
		lg.setLineWidth(2)
		lg.line(selectedPlanet.x + 140, selectedPlanet.y - 80, selectedPlanet.x + 240, selectedPlanet.y - 110)
		lg.line(selectedPlanet.x + 140, selectedPlanet.y - 80, selectedPlanet.x + 240, selectedPlanet.y - 50)


		lg.draw(planetsheet, moonData.quad, selectedPlanet.x + 140, selectedPlanet.y - 80, 0, moonData.scale, moonData.scale, 1024 / 2, 1024 / 2)
		lg.draw(planetsheet, moonData.quad, selectedPlanet.x + 240, selectedPlanet.y - 110, 0, moonData.scale, moonData.scale, 1024 / 2, 1024 / 2)
		lg.draw(planetsheet, moonData.quad, selectedPlanet.x + 240, selectedPlanet.y - 50, 0, moonData.scale, moonData.scale, 1024 / 2, 1024 / 2)

		lg.draw(mooncolony, selectedPlanet.x + 240, selectedPlanet.y - 110, 0, moonData.scale, moonData.scale, 1491 / 2, 1491 /2)
		lg.draw(moonradar, selectedPlanet.x + 240, selectedPlanet.y - 50, 0, moonData.scale, moonData.scale, 1491 / 2, 1491 /2)

		lg.draw(satellitesheet, laserquad, selectedPlanet.x + 200, selectedPlanet.y + 30, 0, 0.2, 0.2, 255/2, 175)
		lg.draw(satellitesheet, shockquad, selectedPlanet.x + 200, selectedPlanet.y + 100, 0, 0.2, 0.2, 255/2, 175)

		lg.setColor(0, 0, 0, 178)
		if selectedPlanet.assoc_moons == nil or table.getn(selectedPlanet.assoc_moons) < 1 then
			lg.rectangle("fill", selectedPlanet.x + 210, selectedPlanet.y - 140, 60, 120)
		else
			lg.rectangle("fill", selectedPlanet.x + 110, selectedPlanet.y - 110, 60, 60)
		end


	end

	lg.pop()
end

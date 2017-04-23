uimanager = {}

function uimanager:mousepressed(x, y, button, istouch)
	local x, y = push:toGame(x, y) -- transform coords to game from letterbox value
	-- only be able to select while game running (not paused)
	if gamestate == "game" then
		-- for each planet besides the sun
		for i, object in pairs(planet) do
			if object ~= planet.sun then
				-- check if within gravity area using distance between two points
				if angle_utils:pointdist(x, y, object.x, object.y) <= object.gravity and selectedPlanet ~= object then
					-- if there is already a selected planet deselect it and scale it back
					if selectedPlanet ~= nil then
						selectedPlanet.scale = selectedPlanet.scale/1.2
					end
					selectedPlanet = object -- select the planet
					object.scale = object.scale*1.2 -- scale the planet
					break -- break the iterator when we select
				-- if mouse not over a planet and something is selected then deselect it
				elseif selectedPlanet ~= nil then
					selectedPlanet.scale = selectedPlanet.scale/1.2
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

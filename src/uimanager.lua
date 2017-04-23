uimanager = {}

function uimanager:mousepressed(x, y, button, istouch)
	local x, y = push:toGame(x, y)
	for i, object in pairs(planet) do
		if object ~= planet.sun then
			if angle_utils:pointdist(x, y, object.x, object.y) <= object.gravity and selectedPlanet ~= object then
				if selectedPlanet ~= nil then
					selectedPlanet.scale = selectedPlanet.scale/1.2
				end
				selectedPlanet = object
				object.scale = object.scale*1.2
				break
			elseif selectedPlanet ~= nil then
				selectedPlanet.scale = selectedPlanet.scale/1.2
				selectedPlanet = nil
			end
		end
	end
end

function uimanager:update(dt)

end

uimanager = {}

function uimanager:mousepressed(x, y, button, istouch)
	local x, y = push:toGame(x, y)
	for i, object in pairs(planet) do
		if object ~= planet.sun then
			if angle_utils:pointdist(x, y, object.x, object.y) <= 1024 * object.scale then
				selectedPlanet = object
			end
		end
	end
end
angle_utils = {}

phi = 2 * math.pi

function angle_utils:pointdir(x1, y1, x2, y2)
	return math.atan2(y1 - y2, x1 - x2) -- return the angle in radians facing from point(x1, y1) to point(x2, y2)
end

function angle_utils:clampdir(angle)
	-- if an angle is greater than 2*pi, wrap it around to fit inside bounds [0, 2*pi]
	while angle > phi do
		angle = angle - phi
	end
	-- if an angle is less than 0, wrap it around to fit inside bounds [0, 2*pi]
	while angle < 0 do
		angle = angle + phi
	end

	return angle
end

function angle_utils:pointdist(x1, y1, x2, y2)
	return math.sqrt((y2 - y1) ^ 2 + (x2 - x1) ^ 2) -- return the distance in pixels from point(x1, y1) to point(x2, y2)
end

function angle_utils:lengthdir_x(dir, length)
	return length * math.cos(dir) -- return the delta x of a line that is [length] pixels long and at angle [dir]
end

function angle_utils:lengthdir_y(dir, length)
	return length * math.sin(dir) -- return the delta y of a line that is [length] pixels long and at angle [dir]
end

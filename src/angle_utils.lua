angle_utils = {}

phi = 2 * math.pi

function angle_utils:pointdir(x1, y1, x2, y2)
	return math.atan2(y1 - y2, x1 - x2)
end

function angle_utils:clampdir(angle)
	while angle > phi do
		angle = angle - phi
	end
	while angle < 0 do
		angle = angle + phi
	end
end

function angle_utils:pointdist(x1, y1, x2, y2)
	return math.sqrt((y2 - y1) ^ 2 + (x2 - x1) ^ 2)
end

function angle_utils:lengthdir_x(dir, length)
	return length * math.cos(dir)
end

function angle_utils:lengthdir_y(dir, length)
	return length * math.sin(dir)
end
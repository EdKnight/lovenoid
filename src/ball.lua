--Ball object
local ball = {}
--object properties
ball.position_x = 300
ball.position_y = 400
ball.speed_x = 200
ball.speed_y = 200
ball.radius = 10
ball.width = 2 * ball.radius
ball.height = 2 * ball.radius
--object functions
function ball.update(dt)
	ball.position_x = ball.position_x + ball.speed_x * dt
	ball.position_y = ball.position_y + ball.speed_y * dt
end
function ball.draw()
	local segments_in_circle = 16
	love.graphics.circle('line', ball.position_x, ball.position_y, ball.radius, segments_in_circle )
end
function ball.rebound(x, y)
	local min_shift = math.min(math.abs(x), math.abs(y))
	if math.abs(x) == min_shift then
		y = 0
	else
		x = 0
	end
	ball.position = ball.position_x + x 
	ball.position = ball.position_y + y
	if x ~= 0 then
		ball.speed_x = -ball.speed_x
	end
	if y ~= 0 then
		ball.speed_y = -ball.speed_y
	end
end
function ball.reposition()
	ball.position_x = 300
	ball.position_y = 400
end

return ball
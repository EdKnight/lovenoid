--Ball object
local ball = {}
--object properties
ball.position_x = 300
ball.position_y = 400
ball.image = love.graphics.newImage("img/ball.png")
ball.x_tile_pos = 0
ball.y_tile_pos = 0
ball.tile_width = 18
ball.tile_height = 18
ball.tileset_width = 18
ball.tileset_height = 18
ball.quad = love.graphics.newQuad(ball.x_tile_pos, ball.y_tile_pos, ball.tile_width, ball.tile_height, ball.tileset_width, ball.tileset_height)
ball.speed_x = 200
ball.speed_y = 200
ball.radius = ball.tile_width / 2
ball.width = 2 * ball.radius
ball.height = 2 * ball.radius
--object functions
function ball.update(dt)
	ball.position_x = ball.position_x + ball.speed_x * dt
	ball.position_y = ball.position_y + ball.speed_y * dt
end
function ball.draw()
	love.graphics.draw(ball.image, ball.quad, ball.position_x - ball.radius, ball.position_y - ball.radius)
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
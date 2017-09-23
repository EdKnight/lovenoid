--collisions!
local collisions = {}
function collisions.resolve_collisions(ball, platform, walls, bricks)
	collisions.ball_platform_collision(ball, platform)
	collisions.ball_bricks_collision(ball, bricks)
	collisions.ball_walls_collision(ball, walls)
	collisions.platform_walls_collision(platform, walls)	
end
--check if rectangles overlap
local function overlap_along_axis(a_pos, b_pos, a_size, b_size)
	local diff = b_pos - a_pos
	local dist = math.abs(diff)
	local overlap = (a_size + b_size) / 2 - dist
	return overlap, diff/dist * overlap
end
function collisions.check_rectangle_overlap(a,b)
	local x_overlap, x_shift = overlap_along_axis(a.position_x, b.position_x, a.width, b.width)
	local y_overlap, y_shift = overlap_along_axis(a.position_y, b.position_y, a.height, b.height)
	local overlap = x_overlap > 0 and y_overlap > 0
	return overlap, x_shift, y_shift
end
--check if the objects in the game overlap
--hitbox of the ball is treated as a rectangle, for the sake of simplicity
function collisions.ball_platform_collision(ball, platform)
	local overlap, shift_ball_x, shift_ball_y 
	overlap, shift_ball_x, shift_ball_y = collisions.check_rectangle_overlap(platform, ball)
	if overlap then
		ball.rebound(shift_ball_x, shift_ball_y)
	end
end
function collisions.ball_bricks_collision(ball, bricks)
	local overlap, shift_ball_x, shift_ball_y 	
	for i, brick in pairs(bricks.current_level_bricks) do
		overlap, shift_ball_x, shift_ball_y = collisions.check_rectangle_overlap(brick, ball)
		if overlap then
			ball.rebound (shift_ball_x, shift_ball_y)
			bricks.brick_hit_by_ball( i, brick, shift_ball_x, shift_ball_y )
		end
	end
end
function collisions.ball_walls_collision(ball, walls)
	local overlap, shift_ball_x, shift_ball_y 
	for _, wall in pairs(walls.current_level_walls) do
		overlap, shift_ball_x, shift_ball_y = collisions.check_rectangle_overlap(wall,ball)
		if overlap then
			ball.rebound (shift_ball_x, shift_ball_y)
		end
	end
end
function collisions.platform_walls_collision(platform, walls)
	local overlap, stop_platform_x, stop_platform_x
	for _, wall in pairs(walls.current_level_walls) do
		--there was a bug because the first argument must be the fixed one, and the second must be the moving one
		--swapping the arguments in the function did it right
		overlap, stop_platform_x, stop_platform_y = collisions.check_rectangle_overlap(wall, platform)
		if overlap then
			platform.stop(stop_platform_x, stop_platform_y)
		end
	end
end

return collisions
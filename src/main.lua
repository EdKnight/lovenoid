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

--Platform object
local platform = {}
--object properties
platform.position_x = 500
platform.position_y = 500
platform.speed_x = 300
platform.width = 70
platform.height = 20
--object functions
function platform.update(dt)
	--controller for platform
	if love.keyboard.isDown("right") then
		platform.position_x = platform.position_x + (platform.speed_x * dt)
	end
	if love.keyboard.isDown("left") then
		platform.position_x = platform.position_x - (platform.speed_x * dt)
	end
end
function platform.draw()
	love.graphics.rectangle('fill', platform.position_x - platform.width / 2, platform.position_y - platform.height / 2, platform.width, platform.height)
end
function platform.stop(x,y)
	platform.position_x = platform.position_x + x
end

--Brick object
local bricks = {}
--object properties
bricks.current_level_bricks = {}
bricks.rows = 8
bricks.columns = 11
bricks.top_left_position_x = 70
bricks.top_left_position_y = 50
bricks.brick_width = 50
bricks.brick_height = 20
bricks.horizontal_distance = 10
bricks.vertical_distance = 15 
--object functions
function bricks.new_brick(position_x, position_y, width, height)
	return({position_x = position_x, position_y = position_y, width = width or bricks.brick_width, height = height or bricks.brick_height })
end
function bricks.update_brick(single_brick)
	--placeholder
end
function bricks.draw_brick(single_brick)
	love.graphics.rectangle('line', single_brick.position_x - single_brick.width / 2, single_brick.position_y - single_brick.height / 2, single_brick.width, single_brick.height)
end
function bricks.add_to_current_level_bricks(brick)
	table.insert(bricks.current_level_bricks, brick)
end
function bricks.draw()
	for _, brick in pairs( bricks.current_level_bricks ) do
		bricks.draw_brick(brick)
	end
end
function bricks.update( dt )
	if #bricks.current_level_bricks == 0 then
		bricks.no_more_bricks = true
	else
		for _, brick in pairs(bricks.current_level_bricks) do
				bricks.update_brick(brick)
		end
	end
end
function bricks.construct_level(level_bricks)
	bricks.no_more_bricks = false
	local row_index = 0
	for row in level_bricks:gmatch( '(.-)\n' ) do
		row_index = row_index + 1
		local col_index = 0
		for bricktype in row:gmatch('.') do
			col_index = col_index + 1
			if bricktype == '#' then
				local new_brick_position_x = bricks.top_left_position_x + (col_index - 1) * (bricks.brick_width + bricks.horizontal_distance)
				local new_brick_position_y = bricks.top_left_position_y + (row_index - 1) * (bricks.brick_height + bricks.vertical_distance)
				local new_brick = bricks.new_brick(new_brick_position_x, new_brick_position_y)
				bricks.add_to_current_level_bricks(new_brick)
			end
		end      
	end   
end
function bricks.brick_hit_by_ball(i, brick, shift_ball_x, shift_ball_y)
	table.remove(bricks.current_level_bricks, i)
end


--Wall object
local walls = {}
--object properties
walls.current_level_walls = {}
walls.wall_thickness = 1
function walls.update_wall(single_wall)
	-- placeholder
end
function walls.draw_wall(single_wall)
	love.graphics.rectangle('fill', single_wall.position_x, single_wall.position_y, single_wall.width, single_wall.height)
end
function walls.new_wall(position_x, position_y, width, height)
   return({position_x = position_x, position_y = position_y, width = width, height = height})
end
function walls.construct_walls()
	-- draws a rectangle with (starting x, starting y, thickness and height of screen) for a wall. Same logic on other walls.
	local left_wall = walls.new_wall(walls.wall_thickness / 2, love.graphics.getHeight() / 2, walls.wall_thickness, love.graphics.getHeight())
	local right_wall = walls.new_wall(love.graphics.getWidth() - walls.wall_thickness / 2, love.graphics.getHeight() / 2, walls.wall_thickness, love.graphics.getHeight())
	local top_wall = walls.new_wall(love.graphics.getWidth() / 2, walls.wall_thickness / 2, love.graphics.getWidth(), walls.wall_thickness)
	local bottom_wall = walls.new_wall(love.graphics.getWidth() / 2, love.graphics.getHeight() - walls.wall_thickness / 2, love.graphics.getWidth(), walls.wall_thickness) 
	walls.current_level_walls["left"] = left_wall	
	walls.current_level_walls["right"] = right_wall
	walls.current_level_walls["top"] = top_wall
	walls.current_level_walls["bottom"] = bottom_wall
end
function walls.draw()
	for _, wall in pairs(walls.current_level_walls) do
		walls.draw_wall(wall)
	end
end
function walls.update(dt)
	for _, wall in pairs(walls.current_level_walls) do
		walls.update_wall(wall)
	end
end

--collisions!
local collisions = {}
function collisions.resolve_collisions()
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
function collisions.platform_walls_collision()
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

--Levels!
local levels = {}
levels.sequence = {}
--each level is a matrix, 1 is where a block is created
levels.sequence[1] = [[
           
### ###  # 
# # #    # 
# # ##   # 
# # #     
### ###  # 
           

]]
levels.sequence[2] = [[

### #   # #
#   #   # #
##  #   ###
#   #   ###
#   ### # #
           

]]
levels.current_level = 1
--new level
function levels.switch_to_next_level()
	if bricks.no_more_bricks then
		if levels.current_level < #levels.sequence then
			levels.current_level = levels.current_level + 1
			bricks.construct_level (levels.sequence[levels.current_level])
			ball.reposition()
		else
			levels.game_finished = true
		end
	end
end


function love.load() --LOVE function called when game loads
	bricks.construct_level(levels.sequence[levels.current_level])
	walls.construct_walls()
end

function love.update(dt) --LOVE function that updates things continually until the game is closed (dt = Delta Time)
	ball.update(dt)
	platform.update(dt)
	bricks.update(dt)
	walls.update(dt)
	levels.switch_to_next_level(bricks)
	collisions.resolve_collisions()
end

function love.draw() --LOVE function that draws things on screen	
	ball.draw()
	platform.draw()
	bricks.draw()
	walls.draw()
	if levels.game_finished then
		love.graphics.printf("Congratulations!\nA winner is you!", 300, 250, 200, "center")
	end
end

function love.quit() --LOVE function called when game closes
	print("X(")
end
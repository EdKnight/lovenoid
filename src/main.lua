--Ball object
local ball = {}
--object properties
ball.position_x = 300
ball.position_y = 300
ball.speed_x = 300
ball.speed_y = 300
ball.radius = 10
--object functions
function ball.update(dt)
	ball.position_x = ball.position_x + ball.speed_x * dt
	ball.position_y = ball.position_y + ball.speed_y * dt
end
function ball.draw()
	local segments_in_circle = 16
	love.graphics.circle('line', ball.position_x, ball.position_y, ball.radius, segments_in_circle )
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
	love.graphics.rectangle('line', platform.position_x, platform.position_y, platform.width, platform.height)
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
	-- placeholder
end
function bricks.draw_brick(single_brick)
	love.graphics.rectangle('line', single_brick.position_x, single_brick.position_y, single_brick.width, single_brick.height)
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
	for _, brick in pairs( bricks.current_level_bricks ) do
		bricks.update_brick(brick)
	end
end
function bricks.construct_level()
   for row = 1, bricks.rows do
      for col = 1, bricks.columns do
         local new_brick_position_x = bricks.top_left_position_x + (col - 1) * (bricks.brick_width + bricks.horizontal_distance)
         local new_brick_position_y = bricks.top_left_position_y + ( row - 1 ) * (bricks.brick_height + bricks.vertical_distance)
         local new_brick = bricks.new_brick(new_brick_position_x, new_brick_position_y)
         bricks.add_to_current_level_bricks(new_brick)
      end      
   end   
end


--Brick object
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
   local left_wall = walls.new_wall(0, 0, walls.wall_thickness, love.graphics.getHeight())
   local right_wall = walls.new_wall(love.graphics.getWidth() - walls.wall_thickness, 0, walls.wall_thickness, love.graphics.getHeight())
   local top_wall = walls.new_wall(0, 0, love.graphics.getWidth(), walls.wall_thickness)
   local bottom_wall = walls.new_wall(0, love.graphics.getHeight() - walls.wall_thickness, love.graphics.getWidth(), walls.wall_thickness) 
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


function love.load()
	bricks.construct_level()
	walls.construct_walls()
end

function love.update(dt)
	ball.update(dt)
	platform.update(dt)
	bricks.update(dt)
	walls.update(dt)

end

function love.draw()		
	ball.draw()
	platform.draw()
	bricks.draw()
	walls.draw()

end

function love.quit()
	print("X(")
end
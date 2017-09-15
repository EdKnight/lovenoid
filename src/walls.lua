--Wall object
local walls = {}
--object properties
walls.current_level_walls = {}
walls.wall_thickness = 1
function walls.update_wall(single_wall)
	-- placeholder
end
function walls.draw_wall(single_wall)
	love.graphics.rectangle('fill', single_wall.position_x - single_wall.width / 2, single_wall.position_y - single_wall. height / 2, single_wall.width, single_wall.height)
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

return walls
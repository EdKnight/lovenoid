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

return bricks
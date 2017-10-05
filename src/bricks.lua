--Brick object
local bricks = {}
--object properties
bricks.image = love.graphics.newImage("img/bricks.png")
bricks.tile_width = 64
bricks.tile_height = 32
bricks.tileset_height = 160
bricks.tileset_width = 384
bricks.current_level_bricks = {}
bricks.rows = 11
bricks.columns = 9
--bricks.top_left_position = vector(70,50)
local simple_break_sound = love.audio.newSource("snd/recordered_glass_norm.ogg","static")
local armored_hit_sound = love.audio.newSource("snd/qubodupImpactMetal_short_norm.ogg","static")
local armored_break_sound = love.audio.newSource("snd/armored_glass_break_short_norm.ogg","static")
local ball_heavyarmored_sound = love.audio.newSource("snd/cast_iron_clangs_11_short_norm.ogg","static")
bricks.top_left_position_x = 70
bricks.top_left_position_y = 50
bricks.brick_width = bricks.tile_width
bricks.brick_height = bricks.tile_height
bricks.horizontal_distance = 10
bricks.vertical_distance = 15 
bricks.no_more_bricks = false	
--object functions
function bricks.new_brick(position_x, position_y, width, height, bricktype)
	return({position_x = position_x, position_y = position_y, width = width or bricks.brick_width, height = height or bricks.brick_height, bricktype = bricktype, quad = bricks.bricktype_to_quad(bricktype)})
end
function bricks.bricktype_to_quad(bricktype)
	local id = bricktype
	local row = math.floor(id/10)
	local col = id % 10
	local x_pos = bricks.tile_width * (col-1)
	local y_pos = bricks.tile_height * (row-1)
	return love.graphics.newQuad(x_pos, y_pos, bricks.tile_width, bricks.tile_height, bricks.tileset_width, bricks.tileset_height)
end
function bricks.update_brick(single_brick)
	--placeholder
end
function bricks.is_simple(single_brick)
	local row = math.floor(single_brick.bricktype / 10)
	return (row == 1)
end
function bricks.is_armored(single_brick)
	local row = math.floor(single_brick.bricktype / 10)
	return (row == 2)
end
function bricks.is_scratched(single_brick)
	local row = math.floor(single_brick.bricktype / 10)
	return (row == 3)
end
function bricks.is_cracked(single_brick)
	local row = math.floor(single_brick.bricktype / 10)
	return (row == 4)
end
function bricks.is_heavyarmored( single_brick )
	local row = math.floor( single_brick.bricktype / 10 )
	return ( row == 5 )
end
function bricks.draw_brick(single_brick)
	love.graphics.draw(bricks.image, single_brick.quad, single_brick.position_x - single_brick.width / 2, single_brick.position_y - single_brick.height / 2)	    
end
function bricks.add_to_current_level_bricks(brick)
	table.insert(bricks.current_level_bricks, brick)
end
function bricks.draw()
	for _, brick in pairs( bricks.current_level_bricks ) do
		bricks.draw_brick(brick)
	end
end
function bricks.update(dt)
	local no_more_bricks = true
	for _, brick in pairs(bricks.current_level_bricks) do
		if bricks.is_heavyarmored(brick) then
			no_more_bricks = no_more_bricks and true
		else
			no_more_bricks = no_more_bricks and false
		end
	end
	bricks.no_more_bricks = no_more_bricks
end
function bricks.construct_level(level_bricks)
	bricks.no_more_bricks = false	
	for row_index, row in ipairs(level_bricks) do
		for col_index, bricktype in ipairs(row) do
			if bricktype ~= 0 then
				local new_brick_position_x = bricks.top_left_position_x + (col_index - 1) * (bricks.brick_width + bricks.horizontal_distance)
				local new_brick_position_y = bricks.top_left_position_y + (row_index - 1) * (bricks.brick_height + bricks.vertical_distance)
				local new_brick = bricks.new_brick(new_brick_position_x, new_brick_position_y, bricks.brick_width, bricks.brick_height, bricktype)
				bricks.add_to_current_level_bricks(new_brick)
			end
		end      
	end   
end
function bricks.brick_hit_by_ball(i, brick, shift_ball_x, shift_ball_y)
	if bricks.is_simple(brick) then
		table.remove(bricks.current_level_bricks, i)
		simple_break_sound:play()
	elseif bricks.is_cracked(brick) then
		table.remove(bricks.current_level_bricks, i)
		armored_break_sound:play()  
	elseif bricks.is_armored(brick) then
		bricks.armored_to_scratched(brick)
		armored_hit_sound:play()
	elseif bricks.is_scratched(brick) then
		bricks.scratched_to_cracked(brick)
		armored_hit_sound:play() 
	elseif bricks.is_heavyarmored(brick) then
		ball_heavyarmored_sound:play()
	end	
end
function bricks.armored_to_scratched(single_brick)
   single_brick.bricktype = single_brick.bricktype + 10
   single_brick.quad = bricks.bricktype_to_quad(single_brick.bricktype)
end

function bricks.scratched_to_cracked(single_brick)
   single_brick.bricktype = single_brick.bricktype + 10
   single_brick.quad = bricks.bricktype_to_quad(single_brick.bricktype)
end
function bricks.clear_current_level_bricks()
	for i in pairs( bricks.current_level_bricks ) do
		bricks.current_level_bricks[i] = nil
	end
end
return bricks
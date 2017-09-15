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

return levels
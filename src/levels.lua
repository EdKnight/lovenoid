--Levels!
local levels = {}
levels.current_level = 1
levels.game_finished = false
levels.sequence = require "levels/sequence"

--new level
function levels.switch_to_next_level(bricks, ball)
	if bricks.no_more_bricks then
		bricks.clear_current_level_bricks()
		if levels.current_level < #levels.sequence then
			levels.current_level = levels.current_level + 1
			level = levels.require_current_level()
			bricks.construct_level (level)
			ball.reposition()
		else
			levels.game_finished = true
			gamestate = "gamefinished"
		end
	end
end

function levels.require_current_level()
	local level_filename = "levels/" .. levels.sequence[levels.current_level]
	local level = require( level_filename )
	return level
end


return levels
--Splitted into various files, better for organization
local ball = require "ball"
local platform = require "platform"
local bricks = require "bricks"
local walls = require "walls"
local collisions = require "collisions"
local levels = require "levels"
local gamestate = "menu"

function love.keyreleased( key, code )
	if key == 'c' then
		bricks.clear_current_level_bricks()
	end
	--When in menu, Enter starts the game and esc quits
	if gamestate == "menu" then
		if key == "return" then
			gamestate = "game"
		elseif key == 'escape' then
			love.event.quit()
		end
	--During the game, esc pauses the game
	elseif gamestate == "game" then 
		if key == "escape" then
			gamestate = "pause"
		end
	--During the pause menu, enter resumes and esc quits
	elseif gamestate == "pause" then 
		if key == "return" then
			gamestate = "game"
		elseif key == 'escape' then
			love.event.quit()
		end
	--when the game finishes, you can start it again or quit
	elseif gamestate == "gamefinished" then
		if key == 'return' then
			levels.game_finished = false
			levels.current_level = 1			
			level = levels.require_current_level()
			bricks.construct_level(level)
			ball.reposition()               
			gamestate = "game"
		elseif key == 'escape' then
			love.event.quit()
      end   
	end
end

function love.load() --LOVE function called when game loads	
	local love_window_width = 800
	local love_window_height = 600
	love.window.setMode(love_window_width, love_window_height, {fullscreen = false})
	level = levels.require_current_level()
	bricks.construct_level(level)
	walls.construct_walls()
end

function love.update(dt) --LOVE function that updates things continually until the game is closed (dt = Delta Time)	
	if gamestate == "menu" then
		--update nothing
	elseif gamestate == "game" then
		ball.update(dt)
		platform.update(dt)
		bricks.update(dt)
		walls.update(dt)
		levels.switch_to_next_level(bricks, ball)
		collisions.resolve_collisions(ball, platform, walls, bricks)
		if levels.game_finished then
			gamestate = "gamefinished" 
		end
	elseif gamestate == "pause" then		
		--do nothing
	elseif gamestate == "gamefinished" then		
		--do nothing
	end
end

function love.draw() --LOVE function that draws things on screen	
	if gamestate == "menu" then
		love.graphics.print("Tutorinoid.\nPress Enter to start ou Esc to quit.", 280, 250)
	elseif gamestate == "pause" then
		ball.draw()
		platform.draw()
		bricks.draw()
		walls.draw()
		love.graphics.print("Game is paused. Press Enter to continue or Esc to quit", 50, 50)
	elseif gamestate == "game" then
		ball.draw()
		platform.draw()
		bricks.draw()
		walls.draw()
	elseif gamestate == "gamefinished" then
		love.graphics.printf("Congratulations!\nA winner is you!\nPress Enter to restart ou Esc to quit.", 300, 250, 200, "center")
	end	
end

function love.quit() --LOVE function called when game closes
	print("X(")
end
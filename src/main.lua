local ball = require "ball"
local platform = require "platform"
local bricks = require "bricks"
local walls = require "walls"
local collisions = require "collisions"
local levels = require "levels"


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
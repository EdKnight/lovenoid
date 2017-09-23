--Platform object
local platform = {}
--object properties
platform.position_x = 500
platform.position_y = 500
platform.image = love.graphics.newImage("img/platform.png")
platform.x_tile_pos = 0
platform.y_tile_pos = 0
platform.tile_width = 85
platform.tile_height = 20
platform.tileset_width = 370
platform.tileset_height = 90
platform.quad = love.graphics.newQuad(platform.x_tile_pos, platform.y_tile_pos, platform.tile_width, platform.tile_height, platform.tileset_width, platform.tileset_height)
platform.speed_x = 300
platform.width = 85
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
	love.graphics.draw(platform.image, platform.quad, platform.position_x - platform.width / 2, platform.position_y - platform.height / 2)
	--love.graphics.rectangle('line', platform.position_x - platform.width / 2, platform.position_y - platform.height / 2, platform.width, platform.height)
end
function platform.stop(x,y)
	platform.position_x = platform.position_x + x
end

return platform
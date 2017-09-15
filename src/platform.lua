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

return platform
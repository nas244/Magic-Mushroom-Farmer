--Class = require "libs.hump.class"
Vector = require "libs.hump.vector"
--GS = require "libs.hump.gamestate"

game={
	enter = function(self)
		self.paused = false
	end,

	leave=function (self)
		
	end,

	draw=function (self)
		love.graphics.setColor(1,1,1,0.9)
		love.graphics.scale(window.width)

		love.graphics.origin()

		for y=1, #map do
        	for x=1, #map[y] do
            	if map[y][x] == 1 then
                	love.graphics.rectangle("line", x * 32, y * 32, 32, 32)
            	elseif map[y][x] == 2 then
                	love.graphics.rectangle("fill", x * 32, y * 32, 32, 32)
            	end
        	end
    	end

	end
}

return game
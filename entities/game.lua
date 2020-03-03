--Class = require "libs.hump.class"
Vector = require "libs.hump.vector"
--GS = require "libs.hump.gamestate"

field={}

game={
	enter = function(self)
		self.paused = false
		n = 0
		for y=0, window.height do
			for x=0, window.width do
				if y%32 == 0 and x%32 == 0 then
					n=n+1
					field[n]={myc = 0, nummush = 0, actionrdy = 0}
				end
			end
			print(n)
		end
		print(n)

	end,

	leave=function (self)
		
	end,

	update = function (self)
		local mx,my = love.mouse.getPosition()
    	local mouseB = keyp.mouse1

    	self.useMouse = false
    	if actions.UD ~= 0 then
      		self.useMouse = false
   		elseif mouse.x ~= 0 or mouse.y ~= 0 then
      		--self.useMouse = true
    	end

		for x=1,901 do
			spread = 0
			--print(field[x].myc)
			--print(field[x].nummush)
			--print(field[x].actionrdy)

			--calculate neighbors effect on spread
			if field[x].myc<100 then
				if x+1<=901 and (x+1)%41~=0 then
					spread = spread + field[x+1].myc
				end
				if x-1>=1 and x%41~=0 then
					spread = spread + field[x-1].myc
				end
				if x+41<=901 then
					spread = spread + field[x+41].myc
				end
				if x-41>=1 then
					spread = spread + field[x-41].myc
				end
			elseif field[x].myc > 100 then
				field[x].myc=100
			end

			
			--calculate new myc
			if spread>0 then
				field[x].myc = field[x].myc + (spread/200)
			end
			--print(x.."="..field[x].myc)

		end

		if mouseB then
			fieldindex=(math.floor(my/32))*41+(math.floor(mx/32)+1)
			print(fieldindex)
			field[fieldindex].myc = 100
		end

	end,

	draw=function (self)
		love.graphics.clear()
		love.graphics.setColor(1,1,1,0.9)
		love.graphics.scale(window.width)
		--print("draw")
		love.graphics.origin()
		n = 0
		for y=0, window.height do
        	for x=0, window.width do
            	if y%32 == 0 and x%32==0 then
            		n=n+1
            		love.graphics.setColor(1,1,1,0.9)
                	love.graphics.rectangle("line", x, y, 32, 32)
                  	love.graphics.setColor(1*(field[n].myc/100),0,0,1)
                	love.graphics.rectangle("fill",x+1,y+1,30,30)
            	end
        	end
    	end

    end

    	

}

return game
--Class = require "libs.hump.class"
Vector = require "libs.hump.vector"
--GS = require "libs.hump.gamestate"

claytiles = {
	dryclay = love.graphics.newImage("assets/clay/dryclayfarm.png"),
	drytillclay = love.graphics.newImage("assets/clay/drytilledclay.png"),
	clay = love.graphics.newImage("assets/clay/clayfarm.png"),
	tillclay = love.graphics.newImage("assets/clay/tilledclay.png"),
	wetclay = love.graphics.newImage("assets/clay/wetclayfarm.png"),
	wettillclay = love.graphics.newImage("assets/clay/wettilledclay.png"),
	vwetclay = love.graphics.newImage("assets/clay/heckenwetclayfarm.png"),
	vwettillclay = love.graphics.newImage("assets/clay/heckenwettilledclay.png"),
}

farmtile = {
	drytillfarm = love.graphics.newImage("assets/tilledfarm/drytilledfarm.png"),
	dryfarm = love.graphics.newImage("assets/untilledfarm/dryuntilledfarm.png"),
	tillfarm = love.graphics.newImage("assets/tilledfarm/tilledfarm.png"),
	farm = love.graphics.newImage("assets/untilledfarm/untilledfarm.png"),
	wettillfarm = love.graphics.newImage("assets/tilledfarm/wettilledfarm.png"),
	wetfarm = love.graphics.newImage("assets/untilledfarm/wetuntilledfarm.png"),
	vwettillfarm = love.graphics.newImage("assets/tilledfarm/heckenwettilledfarm.png"),
	vwetfarm = love.graphics.newImage("assets/untilledfarm/heckenwetuntilledfarm.png"),
}

ferttile = {
	somefert = love.graphics.newImage("assets/fert/somefert.png"),
	lotsfert = love.graphics.newImage("assets/fert/lotfert.png"),
}

field={}

game={
	enter = function(self)
		self.paused = false
		n = 0
		self.mouseaction = 1
		for y=0, window.height do
			for x=0, window.width do
				if y%32 == 0 and x%32 == 0 then
					n=n+1
					ogfert=love.math.random(1,10)/10
					--print(ogfert)
					field[n]={myc = 0, nummush = 0, actionrdy = 0, fert = ogfert, soilqual = 0, water = love.math.random(.1,.5), ogfert = ogfert}
					self.rnd = love.math.random(3)
					if self.rnd == 1 then
						field[n].soilqual=.5
					elseif self.rnd == 2 then
						field[n].soilqual=.8
					else
						field[n].soilqual=1.
					end
				end
			end
		end

	end,

	leave=function (self)
		
	end,

	update = function (self)
		local mx,my = love.mouse.getPosition()
    	local mouseB = keyp.mouse1

    	
    	if actions.seed then
    		self.mouseaction = 1
    	elseif actions.water then
    		self.mouseaction = 2
    	elseif actions.fertilize then
    		self.mouseaction = 3
    	elseif actions.till then
    		self.mouseaction = 4 
    	end

		for x=1,901 do
			spread = 0
			waterdrain = 0
			--print(field[x].myc)
			--print(field[x].nummush)
			--print(field[x].actionrdy)

			--calculate neighbors effect on spread
			if field[x].myc<100 then
				if x+1<=901 and (x+1)%41~=0 then
					spread = spread + field[x+1].myc
					exchange = (field[x+1].water-field[x].water)*.0001
					field[x].water = exchange + field [x].water
					field[x+1].water = -exchange + field[x+1].water
				end
				if x-1>=1 and x%41~=0 then
					spread = spread + field[x-1].myc
					exchange = (field[x-1].water-field[x].water)*.0001
					field[x].water = exchange + field [x].water
					field[x-1].water = -exchange + field[x-1].water
				end
				if x+41<=901 then
					spread = spread + field[x+41].myc
					exchange = (field[x+41].water-field[x].water)*.0001
					field[x].water = exchange + field [x].water
					field[x+41].water = -exchange + field[x+41].water
				if x-41>=1 then
					spread = spread + field[x-41].myc
					exchange = (field[x-41].water-field[x].water)*.0001
					field[x].water = exchange + field [x].water
					field[x-41].water = -exchange + field[x-41].water
				end
			elseif field[x].myc > 100 then
				field[x].myc=100
			end

			
			--calculate new myc
			if spread>0 then
				field[x].myc = field[x].myc + (spread/200)*field[x].fert*field[x].soilqual*field[x].water
				if field[x].myc < 0 then
					field[x].myc = 0
				elseif field[x].myc > 100 then
					field.myc = 100
				end
			end

			if field[x].fert ~= field[x].ogfert then
				diff = field[x].fert - field[x].ogfert
				diff = diff * .0001
				field[x].fert = field[x].fert - diff
			end
			if field[x].water > -0.25 then
				field[x].water = field[x].water - .0001
				if field[x].water < -0.25 then
					field[x].water = -0.25
				elseif field[x].water > 1.0 then
					field[x].water = 1
				end
			end



			
			--print(x.."="..field[x].myc)

		end

		if mouseB then
			fieldindex=(math.floor(my/32))*41+(math.floor(mx/32)+1)
			if self.mouseaction == 1 then
				field[fieldindex].myc = 100
			elseif self.mouseaction == 3 then
				field[fieldindex].fert = field[fieldindex].fert +.5
				if field[fieldindex].fert > 1 then
					field[fieldindex].fert = 1
				end
			elseif self.mouseaction == 2 then
				field[fieldindex].water = 1
			elseif self.mouseaction == 4 then
				if field[fieldindex].soilqual == 0.8 then
					field[fieldindex].soilqual = 1.
				elseif field[fieldindex].soilqual == 0.5 then
					field[fieldindex].soilqual = .7
				end
			end
		end
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
                	watervalue = field[n].water
                	if watervalue < 0 then
                		watervalue = 0
                	end
                  	--love.graphics.setColor(1*(field[n].myc/100),1*(watervalue),1*(field[n].fert),1)
                	--love.graphics.rectangle("fill",x+1,y+1,30,30)
                	--print(field[n].soilqual)
                	if field[n].soilqual == 1 then
                		if field[n].water <= 0 then
                			love.graphics.draw(farmtile.drytillfarm,x,y)
                		elseif field[n].water < 0.3 then
                			love.graphics.draw(farmtile.tillfarm,x,y)
                		elseif field[n].water < 0.6 then
                			love.graphics.draw(farmtile.wettillfarm,x,y)
                		elseif field[n].water <= 1 then
                			love.graphics.draw(farmtile.vwettillfarm,x,y)
                		end
                	elseif field[n].soilqual == 0.8 then
                		if field[n].water <= 0 then
                			love.graphics.draw(farmtile.dryfarm,x,y)
                		elseif field[n].water < 0.3 then
                			love.graphics.draw(farmtile.farm,x,y)
                		elseif field[n].water < 0.6 then
                			love.graphics.draw(farmtile.wetfarm,x,y)
                		elseif field[n].water <= 1 then
                			love.graphics.draw(farmtile.vwetfarm,x,y)
                		end
                	elseif field[n].soilqual == 0.7 then
                		if field[n].water <= 0 then
                			love.graphics.draw(claytiles.drytillclay,x,y)
                		elseif field[n].water < 0.3 then
                			love.graphics.draw(claytiles.tillclay,x,y)
                		elseif field[n].water < 0.6 then
                			love.graphics.draw(claytiles.wettillclay,x,y)
                		elseif field[n].water <= 1 then
                			love.graphics.draw(claytiles.vwettillclay,x,y)
                		end                	
                	else
                		if field[n].water <= 0 then
                			love.graphics.draw(claytiles.dryclay,x,y)
                		elseif field[n].water < 0.3 then
                			love.graphics.draw(claytiles.clay,x,y)
                		elseif field[n].water < 0.6 then
                			love.graphics.draw(claytiles.wetclay,x,y)
                		elseif field[n].water <= 1 then
                			love.graphics.draw(claytiles.vwetclay,x,y)
                		end                	
                	end

                	if field[n].fert > 0.7 then
                		love.graphics.draw(ferttile.lotsfert,x,y)
                		--print(field[n].fert)
                	elseif field[n].fert > 0.3 then
                		love.graphics.draw(ferttile.somefert,x,y)
                		--print(field[n].fert)
                	end

            	end
        	end
    	end

    end
}

return game
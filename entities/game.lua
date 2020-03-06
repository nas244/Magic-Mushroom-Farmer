Class = require "libs.hump.class"
Vector = require "libs.hump.vector"
--GS = require "libs.hump.gamestate"

sidebar = require "entities.sidemenu"

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

myceltiles = {
	babymycel = love.graphics.newImage("assets/mycellium/baby.png"),
	teenmycel = love.graphics.newImage("assets/mycellium/teenager.png"),
	adultmycel = love.graphics.newImage("assets/mycellium/adult.png"),
	grownmycel = love.graphics.newImage("assets/mycellium/adultgrown.png")
}

mushtiles = {
	babymush = love.graphics.newImage("assets/mycellium/babymushroom.png"),
	teenmush = love.graphics.newImage("assets/mycellium/teenmushroom.png"),
	adultmush = love.graphics.newImage("assets/mycellium/adultmushroom.png"),
}

sidebar = {
	bar = love.graphics.newImage("assets/menu/sidebar.png"),
	sythe = love.graphics.newImage("assets/tools/sythe.png"),
	hoe = love.graphics.newImage("assets/tools/hoe.png"),
	fertbag = love.graphics.newImage("assets/tools/fertbag.png"),
	bucket = love.graphics.newImage("assets/tools/bucket.png"),
	cops = love.graphics.newImage("assets/menu/Cops.png")
}

audio = {
	sythesound = love.audio.newSource("assets/audio/sythe.mp3","static"),
	bucketsound = love.audio.newSource("assets/audio/bucket.mp3","static"),
	fertsound = love.audio.newSource("assets/audio/fert.mp3","static"),
	hoesound = love.audio.newSource("assets/audio/dig.mp3","static"),
	soundtrack = love.audio.newSource("assets/audio/track.mp3","static")
}


field={}

mytimer = 0



game={
	enter = function(self,dt)
		self.paused = false
		n = 0
		self.mouseaction = 1
		fertcursor = love.mouse.newCursor("assets/tools/fertbag.png",32,32)
		watercursor = love.mouse.newCursor("assets/tools/bucket.png",32,32)
		hoecursor = love.mouse.newCursor("assets/tools/hoe.png",32,32)
		sythecursor = love.mouse.newCursor("assets/tools/sythe.png",32,32)
		waternum = 9
		fertnum = 9
		seeds = 1
		pastgametime = 0
		audio.soundtrack:setLooping(true)
		audio.soundtrack:play()
		copsarrive = false

		--Sidebar = sidebar()
		for y=0, window.height do
			for x=0, window.width do
				if y%32 == 0 and x%32 == 0 and x< 992 then
					n=n+1
					ogfert=love.math.random(1,10)/10
					--print(ogfert)
					field[n]={myc = 0, nummush = 0, actionrdy = 0, fert = ogfert, soilqual = 0, water = love.math.random(.1,.5), ogfert = ogfert, mushroom = {}}
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
		--print(n)
	end,

	leave=function (self)
		
	end,

	update = function (self,dt)
		local mx,my = love.mouse.getPosition()
    	local mouseB = keyp.mouse1
    	
    	
    	if actions.seed then
    		self.mouseaction = 1
    		love.mouse.setCursor()
    	elseif actions.water then
    		self.mouseaction = 2
    		love.mouse.setCursor(watercursor)
    	elseif actions.fertilize then
    		self.mouseaction = 3
    		love.mouse.setCursor(fertcursor)
    	elseif actions.till then
    		self.mouseaction = 4 
    		love.mouse.setCursor(hoecursor)
    	elseif actions.info then
    		self.mouseaction = 5
    	elseif actions.harvest then
    		self.mouseaction = 6
    		love.mouse.setCursor(sythecursor)
    	end

		for x=1,651 do
			spread = 0
			waterdrain = 0
			--print(field[x].myc)
			--print(field[x].nummush)
			--print(field[x].actionrdy)
			
			--calculate neighbors effect on spread
			if field[x].myc<100 then
				if x+1<=901 and (x+1)%31~=0 then
					spread = spread + field[x+1].myc
					exchange = (field[x+1].water-field[x].water)*.0001
					field[x].water = exchange + field [x].water
					field[x+1].water = -exchange + field[x+1].water
				end
				if x-1>=1 and x%31~=0 then
					spread = spread + field[x-1].myc
					exchange = (field[x-1].water-field[x].water)*.00001
					field[x].water = exchange + field [x].water
					field[x-1].water = -exchange + field[x-1].water
				end
				if x+31<=901 then
					spread = spread + field[x+31].myc
					exchange = (field[x+31].water-field[x].water)*.00001
					field[x].water = exchange + field [x].water
					field[x+31].water = -exchange + field[x+31].water
				if x-31>=1 then
					spread = spread + field[x-31].myc
					exchange = (field[x-31].water-field[x].water)*.00001
					field[x].water = exchange + field [x].water
					field[x-31].water = -exchange + field[x-31].water
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
				field[x].water = field[x].water - .00001
				if field[x].water < -0.25 then
					field[x].water = -0.25
				elseif field[x].water > 1.0 then
					field[x].water = 1
				end
			end

			
			


			
			--print(x.."="..field[x].myc)

		end

		for x=1,651 do
			if field[x].myc >= 90 and field[x].nummush == 0 then
				chance = love.math.random(1000000)
				--print(chance)
				if chance == 1 then
					mushnum = love.math.random(10)
					if mushnum > 9 then
						field[x].nummush = 3
						m = 3
					elseif mushnum > 5 then
						field[x].nummush = 2
						m = 2
					else
						field[x].nummush = 1
						m = 1
					end

					for k=1,m do
					 	field[x].mushroom[k] = {growth = 1}
					end
					 
				end
			end
			if field[x].nummush > 0 then
				for k=1, field[x].nummush do
					if field[x].mushroom[k].growth < 100 then
						growthfactor = love.math.random(10)/1000
						field[x].mushroom[k].growth = field[x].mushroom[k].growth + .05*field[x].fert*field[x].water*field[x].soilqual *growthfactor
						field[x].fert = field[x].fert - 0.000000001
						field[x].water = field[x].water -0.000000001 
					elseif field[x].mushroom[k].growth > 100 then
						field[x].mushroom[k].growth = 100
					end
					--print(field[x].mushroom[k].growth)
				end
			end
		end

		if coptimer < timer  then
			if totalscore > 10 then
				copsarrive = true
			end
			coptimer = love.math.random(60,75)
			timer = 0
		end
		
		mytimer=mytimer + dt

		if mouseB and mytimer > 1 then
			if not copsarrive then
				if mx < 992 then
					fieldindex=(math.floor(my/32))*31+(math.floor(mx/32)+1)
					mytimer = 0
					if self.mouseaction == 1 then
						if seeds > 0 then
							field[fieldindex].myc = 50
							seeds = seeds - 1
						end
					elseif self.mouseaction == 3 then
						if fertnum > 0 and field[fieldindex].fert < 0.95 then
							audio.fertsound:play()
							field[fieldindex].fert = 1
							fertnum = fertnum - 1 
						end
					elseif self.mouseaction == 2 then
						if waternum > 0 and field[fieldindex].water < 0.95 then
							--print("water")
							audio.bucketsound:play()
							field[fieldindex].water = 1
							waternum = waternum - 1
						end 
					elseif self.mouseaction == 4 then
						audio.hoesound:play()
						if field[fieldindex].soilqual == 0.8 then
							field[fieldindex].soilqual = 1.
						elseif field[fieldindex].soilqual == 0.5 then
							field[fieldindex].soilqual = .7
						end
					elseif self.mouseaction == 5 then
						print(field[fieldindex].nummush)
					elseif self.mouseaction == 6 then
						audio.sythesound:play()
						for k=1, field[fieldindex].nummush do
							if field[fieldindex].mushroom[k].growth >= 60 then
								score = score + 1
								totalscore = totalscore + 1
							end
						end
						field[fieldindex].nummush = 0
						field[fieldindex].mushroom = {}
					end
				elseif my < 391 then
					if (mx >= 1072 and mx < 1136) and (my >= 220 and my < 284) then
						actions.till = true
						mouseswitch = true
					elseif (mx >= 1136 and mx <= 1200) and (my >= 220 and my < 284) then
						actions.harvest = true
						mouseswitch = true
					elseif (mx >= 1072 and mx < 1136) and (my >= 284 and my < 348) then
						actions.fertilize = true
							mouseswitch = true
					elseif (mx >=1136 and mx <= 1200) and (my >= 284 and my < 348) then
						actions.water = true
						mouseswitch = true
					end

				elseif my >= 392 then
					if (mx > 992+144-64 and mx < 992 + 144) and (my >= 392 and my < 392+65) and score > 0 and gameTime-5 > pastgametime then
						score = score - 1
						fertnum = fertnum + 3
						pastgametime = gameTime
					elseif (mx >= 992+144 and mx <992+144+64) and (my >= 392 and my < 392+65) and score > 0 and gameTime-5 > pastgametime then
						score = score - 1
						waternum = waternum + 5
						pastgametime = gameTime
					end 
				--print(mx.." "..my)
				end
			else 
				if (mx >= 70 + 256 and mx <= 221 + 256) and (my >= 333+96 and my <= 419+96) and score >= math.floor(totalscore*0.25) then
					score = score - math.floor(totalscore*0.25)
					copsarrive = false
				elseif (mx >= 269 + 256 and mx <= 420 + 256) and (my >= 333+96 and my <= 419+96) then
					love.event.push("quit")
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
		love.graphics.draw(sidebar.bar,992,1)
		love.graphics.draw(sidebar.hoe,992+144-64,220)
		love.graphics.draw(sidebar.sythe,992+144,220)
		love.graphics.draw(sidebar.fertbag,992+144-64,220+64)
		love.graphics.draw(sidebar.bucket,992+144,220+64)
		love.graphics.draw(sidebar.fertbag,992+144-64,392)
		love.graphics.draw(sidebar.bucket,992+144,392)
		love.graphics.setColor(0,0,0,1)
		love.graphics.print(tostring(score), 992+180, 115, 0, 1.9, 1.9)
		love.graphics.print(tostring(seeds), 992+155, 150, 0, 1.9, 1.9)
		love.graphics.print(tostring(waternum), 992+144+48, 220+64+48)
		love.graphics.print(tostring(fertnum),992+144-16,220+64+48)
		love.graphics.setColor(1,1,1,1)
		

		n = 0
		for y=0, window.height do
        	for x=0, window.width do
            	if y%32 == 0 and x%32==0 and x < 992 then
            		n=n+1
            		--love.graphics.setColor(1,1,1,0.9)
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

                	if field[n].myc > 90 then
                		color = false
                		for k = 1, field[n].nummush do
                			if field[n].mushroom[k].growth > 60 then
                				color = true
                			end
                		end
                		if color then
                			love.graphics.draw(myceltiles.grownmycel,x,y)
                		else
							love.graphics.draw(myceltiles.adultmycel,x,y)
						end
                	elseif field[n].myc > 50 then
                		love.graphics.draw(myceltiles.teenmycel,x,y)
                	elseif field[n].myc > 10 then
                		love.graphics.draw(myceltiles.babymycel,x,y)
                	end

                	m = field[n].nummush
                	--postionplace = {{8,8},{0,0,16,16},{0,0,16,0,8,16}}
                	if field[n].nummush > 0 then
                		for k=1, m do
                			if field[n].mushroom[k].growth < 20 then
                				if k == 1 then
                					love.graphics.draw(mushtiles.babymush,x,y)
                				elseif k == 2 then
                					love.graphics.draw(mushtiles.babymush,x+16,y)
                				elseif k == 3 then
                					love.graphics.draw(mushtiles.babymush,x+8,y+16)
                				end
                				--print(field[n].mushroom[k].growth)
                			elseif field[n].mushroom[k].growth < 60 then
                				if k == 1 then
                					love.graphics.draw(mushtiles.teenmush,x,y)
                				elseif k == 2 then
                					love.graphics.draw(mushtiles.teenmush,x+16,y)
                				elseif k == 3 then
                					love.graphics.draw(mushtiles.teenmush,x+8,y+16)
                				end
                			elseif field[n].mushroom[k].growth <= 100 then
                				if k == 1 then
                					love.graphics.draw(mushtiles.adultmush,x,y)
                				elseif k == 2 then
                					love.graphics.draw(mushtiles.adultmush,x+16,y)
                				elseif k == 3 then
                					love.graphics.draw(mushtiles.adultmush,x+8,y+16)
                				end
                			end
                		end	
                	end


            	end
        	end
        if copsarrive == true then
        	love.graphics.setColor(1,1,1,1)
        	love.graphics.draw(sidebar.cops,256,96)
        	love.graphics.setColor(0,0,0,1)
        	love.graphics.print(tostring(math.floor(totalscore*0.25)),256+167,93+394)
        	love.graphics.setColor(1,1,1,.9)
        end

    	end

    end
}

return game
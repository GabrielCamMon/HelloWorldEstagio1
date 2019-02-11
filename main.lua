-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local cont = 0
local background = display.newImageRect("imgs/background.png",800,1400 )
background.x = display.contentCenterX
background.y = display.contentCenterY




local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )
math.randomseed( os.time() )

local sheetOptions =
{
  frames =
  {
    {   -- 1) asteroid 1
            x = 0,
            y = 0,
            width = 102,
            height = 85
        },
        {   -- 2) asteroid 2
            x = 0,
            y = 85,
            width = 90,
            height = 83
        },
        {   -- 3) asteroid 3
            x = 0,
            y = 168,
            width = 100,
            height = 97
        },
        {   -- 4) ship
            x = 0,
            y = 265,
            width = 98,
            height = 79
        },
        {   -- 5) laser
            x = 98,
            y = 265,
            width = 14,
            height = 40
        },
  },
}
local objectSheet = graphics.newImageSheet("imgs/gameObjects.png", sheetOptions)


-- Initialize variables


local asteroidsTable = {}

local ship
local gameLoopTimer

local mainGroup = display.newGroup()




ship = display.newImageRect(mainGroup, objectSheet, 4, 49, 39)
ship.x = display.contentCenterX
ship.y = display.contentHeight - 100
physics.addBody(ship, {radius= 30, isSensor = false})
ship.myName = "ship"


display.setStatusBar( display.HiddenStatusBar )



local function createAsteroid( )
    local newAsteroid  = display.newImageRect(mainGroup, objectSheet, 1 ,51, 43)
    table.insert(asteroidsTable, newAsteroid)
    physics.addBody( newAsteroid, "dynamic", {radius = 40, bounce = 0.8})
     newAsteroid.myName = "asteroid"

     local whereFrom = math.random(3)

     if (whereFrom == 1) then 
        newAsteroid.x = -60
        newAsteroid.y = math.random(500)
        newAsteroid:setLinearVelocity(math.random(40,120), math.random(20,60))
   elseif ( whereFrom == 2 ) then
        -- From the top
        newAsteroid.x = math.random( display.contentWidth )
        newAsteroid.y = -60
        newAsteroid:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    elseif ( whereFrom == 3 ) then
        -- From the right
        newAsteroid.x = display.contentWidth + 60
        newAsteroid.y = math.random( 500 )
        newAsteroid:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
    end
    newAsteroid:applyTorque( math.random( -6,6 ) )
end

local function gameLoop()
 
    -- Create new asteroid
    createAsteroid()
 	
    -- Remove asteroids which have drifted off screen
    for i = #asteroidsTable, 1, -1 do
        local thisAsteroid = asteroidsTable[i]
        
 	
        if ( thisAsteroid.x < -100 or
             thisAsteroid.x > display.contentWidth + 100 or
             thisAsteroid.y < -100 or
             thisAsteroid.y > display.contentHeight + 100 )
        then
            display.remove( thisAsteroid )
            table.remove( asteroidsTable, i )
        end
        break
    end 
end
 



local tapText = display.newText(" ",display.contentCenterX, display.contentCenterY, native.systemFont, 40 )
		tapText:setFillColor( 255, 255, 255 )


local function hello()

	
	cont = cont + 1
		if((cont % 2) ~= 0) then
 			tapText.text =  "Hello World"
 			gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )

		else
			tapText.text =  " "
		end		
end
background:addEventListener( "tap", hello )
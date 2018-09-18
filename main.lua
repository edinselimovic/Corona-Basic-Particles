-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local CBE = require("CBE.CBE")
CBE.listPresets()

-- Start off by localising some common helper variables 
local contWidth = display.contentWidth
local contHeight = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- Create the new Particle Effect "vent" and use Preset "burn"
local vent = CBE.newVent({
	preset = "burn"
})

local function ventCleanUp(obj)
 
	obj:stop()
	obj:destroy()
 
end
 
local function rocketCleanUp(obj)
 
	print( "Transition completed on object: " .. tostring( obj ) )
	display.remove(obj)
	obj = nil
 
end
 
-- Tap Event Listener function to handle each Rocket object tap event
    local function rocketTapped(event)
 
        print("You tapped the rocket!")
     
        local obj = event.target
        local obj_touch_x = event.target.x
        local obj_touch_y = event.target.y
     
        -- Remove the current transition.to
        transition.cancel( obj.trans )
        -- Delete the Touch event listener
        obj:removeEventListener( "tap", rocketTapped )
     
        -- Rotate the rocket to its launch position
        obj.rotation = math.random( 10, 60 )
        local alpha_angle = 90 - obj.rotation
     
        -- Create the new Particle Effect "vent" and use Preset "burn"
        local vent = CBE.newVent({
            preset = "burn",
     
            physics = {
                angles = {{80, 100}},
                scaleRateX = 0.98,
                scaleRateY = 0.98,
                gravityY = 0.3
            }
        })
     
        -- Position the new Particle Effect "vent" at the same location at the tap location
        vent.emitX = obj_touch_x
        vent.emitY = obj_touch_y
     
        -- Shift the rocket image overtop of the rocket burn effect
        obj:toFront()
     
        -- Start the new Particle Effect "vent"
        vent:start()
     
        -- Set the desired rocket blast off speed in pixels/millisecond
        local rocket_speed = 960/2000 -- half the content area in 2 seconds
     
        -- Find x distance to right edge, then multiply by 2 for rocket end trajectory distance and end point
        local delta_x = contWidth - obj_touch_x
        local adj_dist = 2*delta_x
     
        local end_xpos = obj_touch_x + adj_dist 
     
        -- Find y trajectory distance  and end  point
        local opp_dist = adj_dist * math.tan(alpha_angle * math.pi / 180)
     
        local end_ypos = obj_touch_y - opp_dist
     
        -- Find the length of the trajectory
        local hyponen = math.sqrt( adj_dist*adj_dist + opp_dist*opp_dist)
     
        -- For rocket constant speed, find trajectory transition time
        local delta_t = hyponen / rocket_speed
     
        -- Launch the rocket on its new trajectory out of the screen
        transition.to( obj, { time = delta_t,  x = end_xpos, y = end_ypos , transition=easing.linear, onComplete=rocketCleanUp} )
        transition.to( vent, { time = delta_t, delay=50, emitX = end_xpos, emitY = end_ypos , transition=easing.linear, onComplete=ventCleanUp} )
     
    end
     
    local function createNewRocket()
     
        -- Render the rocket image
        local newRocket = display.newImageRect( "rocket_orange.png", 140 , 160 )
     
        -- Add a Tap Event listener to each newRocket object
        newRocket:addEventListener( "tap", rocketTapped )
     
        -- Place the rocket image in the center of the screen and rotate it for left-to-right flight
        newRocket.x = -200
        newRocket.y = math.random(200, contHeight-200) 
        newRocket.rotation = 90
     
        newRocket.trans = transition.to( newRocket, { time = 4000, x = contWidth+200, transition=easing.linear, onComplete=rocketCleanUp} )
     
    end
     
    createNewRocket()
    timer.performWithDelay( 2000, createNewRocket, 0 )
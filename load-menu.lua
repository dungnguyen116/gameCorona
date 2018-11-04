local composer = require("composer")
local scene = composer.newScene()

local widget = require("widget")
local explosionSound = audio.loadSound( "assets/audio/main/soundtrack.wma" )
local dog
local background, bg1, bg2, bg3

local function moveObject(object)
    transition.to(object, {
        y = object.y - 3,
        time = 600,
        onComplete = function ()
            transition.to(object, {
                y = object.y + 3;
                time = 600;
                onComplete = function ()
                    moveObject(object);
                end
            })
        end
    } )
end

local function hideObj(object, rotation)
    transition.to(object, {
        rotation = rotation,
        alpha = 0,
        time = 1000
    })
end
local win

local function spriteImage(animalName, timeLoop, widthImg, heighImg, numFrames, xCoor, yCoor, fName, scaleX, scaleY) 
    local sequence = {
        name = "sprite",
        start = 1,
        count = numFrames,
        time = timeLoop,
        loopDirection = "forward";
    }
    local options = {
        width = widthImg,
        height = heighImg,
        numFrames = numFrames
    }
    
    local sheet = graphics.newImageSheet(animalName, options)
    win = display.newSprite(sheet, sequence);
    win:scale(scaleX, scaleY);
    win.x = xCoor;
    win.y = yCoor;
    win:setSequence("sprite");
    win:play();
    timer.performWithDelay( 3000, fName);
end
local function displayLogo()
    display.remove(win)
    hideObj(bg1, 60)
    hideObj(bg2, -60)
    hideObj(bg3, -60)
    composer.gotoScene("menu",{time = 1000, effect="crossFade"})
end

function scene:create(event)
    -- body
    local sceneGroup = self.view
    audio.play( explosionSound )
    background = display.newImageRect(sceneGroup, "assets/img/main/main-background.png", 300, 500)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    bg1 = display.newImageRect(sceneGroup, "assets/img/main/bg1.png", 60, 120)
    bg1.x = display.contentCenterX * 0.6
    bg1.y = display.contentCenterY * 1.7
    bg2 = display.newImageRect(sceneGroup, "assets/img/main/bg2.png", 110, 180)
    bg2.x = display.contentCenterX * 1.2
    bg2.y = display.contentCenterY * 1.7
    bg3 = display.newImageRect(sceneGroup, "assets/img/main/bg3.png", 150, 200)
    bg3.x = display.contentCenterX * 1.55
    bg3.y = display.contentCenterY * 1.8
    moveObject(bg3)
    spriteImage("assets/img/main/init-ani.png", 1500, 75.6, 79, 16, display.contentCenterX, display.contentCenterY * 0.8, displayLogo, 1.2, 1.2)
end
function scene:show(event)
    -- body
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        -- This will destroy the game scene when available
    end
end
function scene:hide(event)
    -- body
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
    end
end
function scene:destroy(event)
    -- body
    local sceneGroup = self.view
    
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
local composer = require("composer")
local scene = composer.newScene()

local widget = require("widget")
local btnStartFight
local win
local searchFriend
local globalFont = native.newFont("assets/fonts/UVFCinnamonCake.ttf", 16)
local function spriteImage(animalName, timeLoop, widthImg, heighImg, numFrames, xCoor, yCoor, fName) 
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
    win:scale(0.35, 0.35);
    win.x = xCoor;
    win.y = yCoor;
    win:setSequence("sprite");
    win:play();
    timer.performWithDelay( 3000, fName);
end
local function rotateObj(object)
    transition.to(object, {
        rotation = 0.8,
        y = object.y + 5,
        time = 1000,
        onComplete = function ()
            transition.to(object, { 
                rotation = -0.8,
                y = object.y - 5,
                time = 1000,
                onComplete = function ()
                    rotateObj(object);
                end
            })
        end
    })
end
local function showButton(object)
    transition.to(object, {
        y = object.y + 5,
        alpha = 1,
        time = 1500
    })
end

local function onStartFightTouch(event)
    if ("ended" == event.phase) then
		composer.removeScene("fight")
        composer.gotoScene("menu-game-fight", {time="500", effect="fade"})
    end
end
function scene:create(event)
    local sceneGroup = self.view
    
    local background = display.newImageRect(sceneGroup, "assets/img/main/main-background.png", 300, 500)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    local mainUser
    btnStartFight = widget.newButton({
        width = 150,
        height = 70,
        defaultFile = "assets/img/main/btnStartFight.png",
        overFile = "assets/img/main/btnStartFight_pressed.png",
        onEvent = onStartFightTouch
    })
    
    btnStartFight.x = display.contentCenterX
    btnStartFight.y = display.contentCenterY * 1.65
    btnStartFight.alpha = 0
	sceneGroup:insert(btnStartFight)
    searchFriend = display.newImageRect(sceneGroup, "assets/img/main/searchFriend.png", 200, 40)
    searchFriend.x = display.contentCenterX
    searchFriend.y = display.contentCenterY * 0.5
end

function scene:show(event)
    -- body
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
		
    local function displayUser()
        display.remove(win)
        mainUser = display.newImageRect(sceneGroup, "assets/img/main/main-user.png", 140, 180)
        mainUser.x = display.contentCenterX
        mainUser.y = display.contentCenterY
        showButton(btnStartFight)    
        rotateObj(btnStartFight)
    end

    spriteImg = spriteImage("assets/img/main/user.png", 700, 411, 519, 5, display.contentCenterX, display.contentCenterY, displayUser)
	
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
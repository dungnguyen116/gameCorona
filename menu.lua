local composer = require("composer")
local scene = composer.newScene()

local widget = require("widget")
local backgroundSound = audio.loadStream( "assets/audio/main/soundtrack.wav" )
composer.setVariable("backgroundSound",backgroundSound)
local dog
local background, bg1, bg2, bg3, btnStart, btnIntro
local sceneGroup

local function moveObject(object)
    transition.to(object, {
        y = object.y - 3,
        time = 600,
        onComplete = function()
            transition.to(object, {
                y = object.y + 3;
                time = 600;
                onComplete = function()
                    moveObject(object);
                end
            })
        end
    })
end

local function hideObj(object, rotation)
    transition.to(object, {
        rotation = rotation,
        alpha = 0,
        time = 1000
    })
end

local function showButton(object)
    transition.to(object, {
        y = object.y + 5,
        alpha = 1,
        time = 500
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
    timer.performWithDelay(3000, fName);
end

local function rotateObj(object)
    transition.to(object, {
        rotation = 0.3,
        y = object.y + 0.5,
        time = 700,
        onComplete = function()
            transition.to(object, {
                rotation = -0.3,
                y = object.y - 0.5,
                time = 700,
                onComplete = function()
                    rotateObj(object);
                end
            })
        end
    })
end

local function onStartTouch(event)
    if ("ended" == event.phase) then
        composer.gotoScene("menu-game", {time = "500", effect = "fade"})
        display.remove(win)
    end
end

local function onIntroduceTouch(event)
    if ("ended" == event.phase) then
        composer.gotoScene("introduction", {time = "500", effect = "fade"})
        display.remove(win)
    end
end

local logo
local btnSoundOn
local btnSoundOff

local function onBtnSoundOn(event)
    if ("ended" == event.phase) then
        btnSoundOn.alpha = 0
        btnSoundOff.alpha = 1
        audio.stop()
    end
end

local function onBtnSoundOff(event)
    if ("ended" == event.phase) then
        btnSoundOn.alpha = 1
        btnSoundOff.alpha = 0
        audio.play(backgroundSound,{loops=-1})
    end
end

function scene:create(event)
    -- body
    sceneGroup = self.view
    audio.play(explosionSound)
    background = display.newImageRect(sceneGroup, "assets/img/main/main-background.png", 300, 500)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    logo = display.newImageRect("assets/img/main/logo.png", 200, 200)
    logo.x = display.contentCenterX
    logo.y = display.contentCenterY * 0.7
    logo.alpha = 0
    
    btnStart = widget.newButton({
        width = 130,
        height = 80,
        defaultFile = "assets/img/main/btnStart.png",
        overFile = "assets/img/main/btnStart_pressed.png",
        onEvent = onStartTouch
    })
    sceneGroup:insert(btnStart)
    btnStart.x = display.contentCenterX
    btnStart.y = display.contentCenterY * 1.5
    btnStart.alpha = 0
    
    btnIntro = widget.newButton({
        width = 100,
        height = 22,
        defaultFile = "assets/img/main/btnIntro.png",
        overFile = "assets/img/main/btnIntro_pressed.png",
        onEvent = onIntroduceTouch
    })
    sceneGroup:insert(btnIntro)
    btnIntro.x = display.contentCenterX
    btnIntro.y = display.contentCenterY * 1.9
    btnIntro.alpha = 0
    
    btnSoundOn = widget.newButton({
        width = 45,
        height = 45,
        defaultFile = "assets/img/main/btnSpeaker_on.png",
        onEvent = onBtnSoundOn
    })
    sceneGroup:insert(btnSoundOn)
    btnSoundOn.x = display.contentCenterX * 0.35
    btnSoundOn.y = display.contentCenterY * 0.1
    btnSoundOn.alpha = 0
    
    btnSoundOff = widget.newButton({
        width = 45,
        height = 45,
        defaultFile = "assets/img/main/btnSpeaker_off.png",
        onEvent = onBtnSoundOff
    })
    sceneGroup:insert(btnSoundOff)
    btnSoundOff.x = display.contentCenterX * 0.35
    btnSoundOff.y = display.contentCenterY * 0.13
    btnSoundOff.alpha = 0
    hideObj(bg1, 60)
    hideObj(bg2, -60)
    hideObj(bg3, -60)
    transition.to(logo, {
        alpha = 1,
        time = 500,
        y = logo.y + 5
    })
    showButton(btnStart)
    showButton(btnIntro)
    showButton(btnSoundOn)
    sceneGroup:insert(logo)
    
    moveObject(btnStart)
    spriteImage("assets/img/main/welcome.png", 600, 148, 148, 6, display.contentCenterX * 0.5, display.contentCenterY * 1.6, nil, 0.8, 0.8)
end
function scene:show(event)
    -- body
    local sceneGroup = self.view
    local phase = event.phase
    
    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        elseif (phase == "did") then
        -- Code here runs when the scene is entirely on screen
        -- This will destroy the game scene when available
        end
end
function scene:hide(event)
    -- body
    local sceneGroup = self.view
    local phase = event.phase
    if (phase == "will") then
        
        -- Code here runs when the scene is on screen (but is about to go off screen)
        elseif (phase == "did") then
        -- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene("menu")
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

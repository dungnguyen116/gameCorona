local composer = require("composer")
local scene = composer.newScene()
local backgroundsound = composer.getVariable("backgroundsound");
local widget = require("widget")
local _S = {}
_S.W = display.contentWidth
_S.H = display.contentHeight
_S.CX = math.floor(_S.W / 2) -- Middle along x-axis
_S.CY = math.floor(_S.H / 2) -- Middle along y-axis
local function rotateObj(object)
    transition.to(object, {
        rotation = 0.2,
        y = object.y + 0.5,
        time = 600,
        onComplete = function ()
            transition.to(object, { 
                rotation = -0.2,
                y = object.y - 0.5,
                time = 600,
                onComplete = function ()
                    rotateObj(object);
                end
            })
        end
    })
end
local function moveObject(object)
	transition.to(object, {
		y = object.y - 5,
		time = 500,
		onComplete = function ()
			transition.to(object, {
				y = object.y + 5;
				time = 500;
				onComplete = function ()
					moveObject(object);
				end
			})
		end
	} )
end
local function onMusicGame(event)
    if ("ended" == event.phase) then
        audio.stop();
        composer.gotoScene("MusicGame.scenes.menuD", {time="500", effect="fade"})
    end
end

local function onAnimalGame(event)
    if ("ended" == event.phase) then
        audio.stop();
        composer.gotoScene("AnimalImg.menuv", {time="500", effect="fade"})
    end
end
local function backToMenu( event ) -- Return the player to the menu
    if ( "ended" == event.phase ) then
        composer.gotoScene("menu",{time = 500, effect="crossFade"})
		
    end
end
function scene:create(event)
    local sceneGroup = self.view
    local background = display.newImageRect(sceneGroup, "assets/img/main/main-background.png", 300, 500)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
	local btn_backToMenu = widget.newButton({
      width = 165,
      height = 139,
      defaultFile = "assets/img/MusicGame/game/back_btn.png",
      overFile = "assets/img/MusicGame/game/back_pressed_btn.png",
	  onEvent = backToMenu
    })
	btn_backToMenu:scale(0.3,0.3)
    btn_backToMenu.x = _S.CX *0.4
    btn_backToMenu.y = _S.CY * 0.15
    moveObject(btn_backToMenu)
    sceneGroup:insert(btn_backToMenu)
    local btnMusicGame = widget.newButton({
        width = 225,
        height = 135,
        defaultFile = "assets/img/main/btnMusicGame.png",
        overFile = "assets/img/main/btnMusicGame_pressed.png",
        onEvent = onMusicGame
    })
    sceneGroup:insert(btnMusicGame)
    btnMusicGame.x = display.contentCenterX
    btnMusicGame.y = display.contentCenterY * 0.6
    rotateObj(btnMusicGame)

    local btnAnimalImg = widget.newButton({
        width = 225,
        height = 135,
        defaultFile = "assets/img/main/btnAnimalImg.png",
        overFile = "assets/img/main/btnAnimalImg_pressed.png",
        onEvent = onAnimalGame
    })
    sceneGroup:insert(btnAnimalImg)
    btnAnimalImg.x = display.contentCenterX
    btnAnimalImg.y = display.contentCenterY * 1.35
    rotateObj(btnMusicGame)
    rotateObj(btnAnimalImg)
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
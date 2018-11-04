local composer = require("composer")
local scene = composer.newScene()

local widget = require("widget")

local _S = {}
_S.W = display.contentWidth
_S.H = display.contentHeight
_S.CX = math.floor(_S.W / 2) -- Middle along x-axis
_S.CY = math.floor(_S.H / 2) -- Middle along y-axis
local function backToMenu( event ) -- Return the player to the menu
    if ( "ended" == event.phase ) then
        composer.gotoScene("menu",{time = 500, effect="crossFade"})
		
    end
end
function scene:create(event)
    -- body
    local sceneGroup = self.view

    local background = display.newImageRect(sceneGroup, "assets/img/main/main-background.png", 300, 500)
    background.x = _S.CX
    background.y = _S.CY

	local team = display.newImageRect(sceneGroup, "assets/img/main/introdution.png", 300, 500)
    team.x = _S.CX
    team.y = _S.CY
	
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
    sceneGroup:insert(btn_backToMenu)
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
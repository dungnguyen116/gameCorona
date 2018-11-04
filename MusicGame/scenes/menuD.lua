local composer = require("composer")
local scene = composer.newScene()
local musicTrack = audio.loadStream("assets/audio/MusicGame/backgroundmusic-babyshark.wav")
local widget = require("widget")
local highScore
local hScore
local backgroundMusicChannel
--local json = require("json")
--local filePath = system.pathForFile("scores.json", system.DocumentsDirectory)
math.randomseed(os.time())
-- Reserve channel 1 for background music
audio.reserveChannels(1)
-- Reduce the overall volume of the channel
audio.setVolume(0.5, {channel = 1})
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
local _S = {}
_S.W = display.contentWidth
_S.ACW = display.actualContentWidth
_S.ACH = display.actualContentHeight
_S.H = display.contentHeight
_S.T = display.screenOriginY -- Top
_S.L = display.screenOriginX -- Left
_S.R = display.viewableContentWidth - _S.L -- Right
_S.B = display.viewableContentHeight - _S.T
-- Bottom
_S.CX = math.floor(_S.W / 2) -- Middle along x-axis
_S.CY = math.floor(_S.H / 2) -- Middle along y-axis
-- -----------------------------------------------------------------------------------
local function moveObject(object)
    transition.to(
        object,
        {
            y = object.y - 5,
            time = 500,
            onComplete = function()
                transition.to(
                    object,
                    {
                        y = object.y + 5,
                        time = 500,
                        onComplete = function()
                            moveObject(object)
                        end
                    }
                )
            end
        }
    )
end
-- -----------------------------------------------------------------------------------
local function rotateObj(object)
    transition.to(
        object,
        {
            rotation = 0.6,
            y = object.y + 0.2,
            time = 700,
            onComplete = function()
                transition.to(
                    object,
                    {
                        rotation = -0.6,
                        y = object.y - 0.2,
                        time = 700,
                        onComplete = function()
                            rotateObj(object)
                        end
                    }
                )
            end
        }
    )
end
-- Return player to menu
local function onMenuTouch(event)
    if ("ended" == event.phase) then
        composer.gotoScene("MusicGame.scenes.game", {time = 500, effect = "crossFade"})
        -- Stop the music!
        audio.stop(1)
    end
end

local function gotoHighScores()
    composer.gotoScene("MusicGame.scenes.highscores", {time = 800, effect = "crossFade"})
end
-- -----------------------------------------------------------------------------------
local function backToMenuGame(event) -- Return the player to the menu
    if ("ended" == event.phase) then
        audio.stop()
        local backgroundSound = composer.getVariable("backgroundSound")
        audio.play(backgroundSound)

        composer.gotoScene("menu-game", {time = 500, effect = "crossFade"})
    end
end
-- create()
function scene:create(event)
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    local background = display.newImageRect(sceneGroup, "assets/img/MusicGame/menu/background.png", 300, 500) -- add a background
    background.x = _S.CX
    background.y = _S.CY
    local btn_backToMenuGame =
        widget.newButton(
        {
            width = 165,
            height = 139,
            defaultFile = "assets/img/MusicGame/game/back_btn.png",
            overFile = "assets/img/MusicGame/game/back_pressed_btn.png",
            onEvent = backToMenuGame
        }
    )
    btn_backToMenuGame:scale(0.3, 0.3)
    btn_backToMenuGame.x = _S.CX * 0.4
    btn_backToMenuGame.y = _S.CY * 0.15
    sceneGroup:insert(btn_backToMenuGame)
    moveObject(btn_backToMenuGame)
    local logo = display.newImageRect(sceneGroup, "assets/img/MusicGame/menu/logo.png", _S.W, 180) -- add a logo
    logo.x = _S.CX
    logo.y = display.contentCenterY * 0.7
    rotateObj(logo)
    local btn_play =
        widget.newButton(
        {
            -- add the play button
            width = 150,
            height = 70,
            defaultFile = "assets/img/MusicGame/menu/play_btn.png",
            overFile = "assets/img/MusicGame/menu/play_btn_pressed.png",
            onEvent = onMenuTouch
        }
    )
    btn_play.x = _S.CX
    btn_play.y = display.contentCenterY * 1.4
    sceneGroup:insert(btn_play)

    local btn_highscore =
        widget.newButton(
        {
            -- add the play button
            width = 150,
            height = 70,
            defaultFile = "assets/img/MusicGame/menu/btn_highscore.png",
            overFile = "assets/img/MusicGame/menu/btn_highscore_pressed.png",
            onEvent = gotoHighScores
        }
    )
    btn_highscore.x = _S.CX
    btn_highscore.y = display.contentCenterY * 1.7
    sceneGroup:insert(btn_highscore)
    -- If you'd like to make editions of this game, you can announce them here. You can add items like Superhero Edition or TV Edition and customize the word list accordingly.
    local gameEdition = display.newText(sceneGroup, "", 0, 0, native.systemFontBold, 46)
    gameEdition.x = _S.CX
    gameEdition.y = btn_play.y + (btn_play.height * 0.8)
    gameEdition:setFillColor(66 / 255, 66 / 255, 66 / 255)
    moveObject(btn_play)
    moveObject(btn_highscore)
end

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif (phase == "did") then
        -- Code here runs when the scene is entirely on screen
        -- This will destroy the game scene when available
        local prevScene = composer.getSceneName("previous")
        if (prevScene) then
            composer.removeScene(prevScene)
        end
    end
    backgroundMusicChannel = audio.play(musicTrack, {channel = 1, loops = -1})
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is on screen (but is about to go off screen)
    elseif (phase == "did") then
    -- Code here runs immediately after the scene goes entirely off screen
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene

local composer = require("composer")
local widget = require("widget")
local scene = composer.newScene()
local sceneGroup
local mainGroup
local background
local animalAnswer = {}
local btn_returnToMenu,btn_backToMenuHome
local questionText,questionTextLine2
local btn_choice, btn_choice2
local score = 0
local question, answerHideRight, answerHideWrong ,scoreBar,lifebarBoxes, clock , star
local animalArrayAnswer = {1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21}
local animalArrayName = {"Thằn Lằn", "Vịt", "Cào Cào", "Cá Vàng", "Voi", "Mèo", "Ếch","Gà","Heo","Thiên Nga","Chim"}
local animalArrayMusic = {"thanlan", "vit", "caocao", "cavang", "voi", "meo", "ech","ga","heo","thiennga","chim"}
local pos = math.random(#animalArrayAnswer)
local randomAnimal = animalArrayName[pos]
local randomMusic = animalArrayMusic[pos]
local rightAnswer = animalArrayAnswer[pos]
local arrayAnswer = {}

table.insert(arrayAnswer, rightAnswer)
local wrongAnswer = animalArrayAnswer[math.random(#animalArrayAnswer)]

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

local function checkValueInArray(arrayAnswer, valueAnswer)
    for key, value in pairs(arrayAnswer) do
        --print("Value: " .. valueAnswer)
        --print("Right: " .. rightAnswer .. " Wrong: " .. wrongAnswer)
        if value == valueAnswer then
            wrongAnswer = animalArrayAnswer[math.random(#animalArrayAnswer)]
            checkValueInArray(arrayAnswer, wrongAnswer)
            return false
        else
            table.insert(arrayAnswer, wrongAnswer)
            return true
        end
    end
end
checkValueInArray(arrayAnswer, wrongAnswer)

local function shuffleTable(t)
    local rand = math.random
    assert(t, "shuffleTable() expected a table, got nil")
    local iterations = #t
    local j

    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
end
shuffleTable(arrayAnswer)

local sqlite3 = require( "sqlite3" )
-- Open "data.db". If the file doesn't exist, it will be created
local path = system.pathForFile( "data.db", system.DocumentsDirectory )

local db = sqlite3.open( path ) 
-- Handle the "applicationExit" event to close the database
local function onSystemEvent( event )
    if ( event.type == "applicationExit" ) then 
        db:close()
    end
end
  -- Setup the event listener to catch "applicationExit"
Runtime:addEventListener( "system", onSystemEvent )
print(randomMusic)
for row in db:nrows("SELECT * FROM tblMusicGame where name = '" ..  randomMusic.."'") do
	filePath = row.content;
end
local gameSound = audio.loadSound( filePath );
local rightsound = audio.loadSound("assets/audio/MusicGame/rightsound.wav")
local wrongsound = audio.loadSound("assets/audio/MusicGame/wrongsound.wav")
local losesound = audio.loadSound("assets/audio/MusicGame/losesound.wav")
audio.reserveChannels(2)
audio.setVolume(0.2, {channel = 2})
local animalOptions = {
    frames = {
        {
            -- 1) than lan
            x = 0,
            y = 0,
            width = 250,
            height = 250
        },
        {
            x = 250,
            y = 0,
            width = 250,
            height = 250
        },
        {
            -- 2) vit
            x = 500,
            y = 0,
            width = 250,
            height = 250
        },
        {
            x = 750,
            y = 0,
            width = 250,
            height = 250
        },
        {
            -- 3) cao cao
            x = 1000,
            y = 0,
            width = 250,
            height = 250
        },
        {
            x = 1250,
            y = 0,
            width = 250,
            height = 250
        },
        {
            -- 4) cao cao
            x = 1500,
            y = 0,
            width = 250,
            height = 250
        },
        {
            x = 1750,
            y = 0,
            width = 250,
            height = 250
        },
        {
            -- 5) Voi
            x = 0,
            y = 250,
            width = 250,
            height = 250
        },
        {
            x = 250,
            y = 250,
            width = 250,
            height = 250
        },
        {
            -- 6) Meo
            x = 500,
            y = 250,
            width = 250,
            height = 250
        },
        {
            x = 750,
            y = 250,
            width = 250,
            height = 250
        },
        {
            -- 7) Ech
            x = 1000,
            y = 250,
            width = 250,
            height = 250
        },
        {
            x = 1250,
            y = 250,
            width = 250,
            height = 250
        },
        {
            -- 8) ga
            x = 1500,
            y = 250,
            width = 250,
            height = 250
        },
        {
            x = 1750,
            y = 250,
            width = 250,
            height = 250
        },
        {
            -- 9) Heo
            x = 0,
            y = 500,
            width = 250,
            height = 250
        },
        {
            x = 250,
            y = 500,
            width = 250,
            height = 250
        },
        {
            -- 10) thien nga
            x = 500,
            y = 500,
            width = 250,
            height = 250
        },
        {
            x = 750,
            y = 500,
            width = 250,
            height = 250
        },
        {
            -- 11) chim
            x = 1000,
            y = 500,
            width = 250,
            height = 250
        },
        {
            x = 1250,
            y = 500,
            width = 250,
            height = 250
        },
        {
            -- 11) chim
            x = 1500,
            y = 500,
            width = 250,
            height = 250
        },
        {
            x = 1750,
            y = 500,
            width = 250,
            height = 250
        }
    }
}
local animalSheet = graphics.newImageSheet("assets/img/MusicGame/game/animal.png", animalOptions)
local animalAnswerSheet = graphics.newImageSheet("assets/img/MusicGame/game/animal-answer.png", animalOptions)
local timerBar, tmr_moveTimerBar  -- declares the bar the player sees and the timer we use
local timerBarScale = 1 -- The scale of the timer bar starts at 1, or 100%

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"

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
local function loadNewAnswer()
    pos = math.random(#animalArrayAnswer)
    randomAnimal = animalArrayName[pos]
    randomMusic = animalArrayMusic[pos]
    rightAnswer = animalArrayAnswer[pos]
    for row in db:nrows("SELECT * FROM tblMusicGame where name = '" ..  randomMusic.."'") do
        filePath = row.content;
    end
    gameSound = audio.loadSound( filePath );
    arrayAnswer = {}
    table.insert(arrayAnswer, rightAnswer)
    wrongAnswer = animalArrayAnswer[math.random(#animalArrayAnswer)]
    checkValueInArray(arrayAnswer, wrongAnswer)
    shuffleTable(arrayAnswer)
    animalSheet = graphics.newImageSheet("assets/img/MusicGame/game/animal.png", animalOptions)
end
local function showResult()
    display.remove(timerBar)
    question.alpha = 0
    clock.alpha = 0
    btn_choice.alpha = 0
    btn_choice2.alpha = 0
    questionText.y = _S.CY * 0.3
    questionTextLine2.y = _S.CY * 0.4
    lifebarBoxes.alpha = 0
end
local function nextGame()
    timerBarScale = 1
    loadNewAnswer()
    scene:create()
    audio.stop(2)
    audio.reserveChannels(2)
    timer.resume(tmr_moveTimerBar)
    audio.setVolume(0.2, {channel = 2})
    audio.play(gameSound, {channel = 2})
end
local function onCheckAnswer(event)
    checkAnswer = event.target.answer
    if ("ended" == event.phase) then
        if (checkAnswer == rightAnswer) then
            score = score + 1
            scoreBar.text = "+ 1"
            star.x = _S.CX * 1.2
            star.y = _S.CY * 1.8
            timer.pause(tmr_moveTimerBar)
            answerHideRight.alpha = 1
            questionText.text = "Đây là"
            questionTextLine2.text = "con " .. randomAnimal
            audio.play(rightsound)
        else
            local alert = display.newText(sceneGroup, "Sai Rồi", _S.CX, _S.CY * 0.2, "iCiel Crocante", 20)
            questionText.text = "Đây không phải là"
            questionTextLine2.text = "con " .. randomAnimal
            answerHideWrong.alpha = 1
            timer.pause(tmr_moveTimerBar)
            alert:setFillColor(255 / 255, 0 / 255, 0 / 255)
            audio.play(wrongsound)
        end
        showResult()
        timer.performWithDelay(3000, nextGame)
    end
end
local function onBackTouch(event) -- Return the player to the menu
    if ("ended" == event.phase) then
        audio.stop()
        timer.cancel(tmr_moveTimerBar)
        composer.removeScene("MusicGame.scenes.game")
        composer.gotoScene("MusicGame.scenes.menuD", {time = 500, effect = "crossFade"})
    end
end
local function moveTimerBar() -- Reduce the timer bar to simulate a time limit within the game. Once timer bar hits 0, it's game over.
    timerBarScale = timerBarScale - 0.003
    timerBar.xScale = timerBarScale

    if (timerBarScale <= 0) then -- on game over, stop the game and display the current word
        timer.cancel(tmr_moveTimerBar)
        display.remove(timerBar)
        question.alpha = 0
        btn_choice.alpha = 0
        btn_choice2.alpha = 0
        questionText.text = "Đây là"
        questionTextLine2.text = "con " .. randomAnimal
        questionText.y = _S.CY * 0.3
        questionTextLine2.y = _S.CY * 0.4
        btn_backToMenuHome.alpha = 0
        btn_returnToMenu.alpha = 1
        answerHideRight.alpha = 1
        lifebarBoxes.alpha = 0
        clock.alpha = 0
        scoreBar.y = _S.CY * 1.4
        star.y = _S.CY * 1.4
        audio.play(losesound)
        composer.setVariable("finalScore", score)
    end
end
-- -----------------------------------------------------------------------------------
-- create(), Code here runs when the scene is first created but has not yet appeared on screen
function scene:create(event)
    sceneGroup = self.view
    background = display.newImageRect(sceneGroup, "assets/img/MusicGame/game/gamebackground.png", 300, 500)
    background.x = _S.CX
    background.y = _S.CY

    ---- Tutorial button
    btn_backToMenuHome =
        widget.newButton(
        {
            width = 150,
            height = 150,
            defaultFile = "assets/img/MusicGame/game/backhome.png",
            overFile = "assets/img/MusicGame/game/backhome-pressed.png",
            onEvent = onBackTouch
        }
    )
    btn_backToMenuHome:scale(0.3, 0.3)
    btn_backToMenuHome.x = _S.CX * 0.35
    btn_backToMenuHome.y = _S.CY * 0.15
    moveObject(btn_backToMenuHome)
    sceneGroup:insert(btn_backToMenuHome)
    scoreBar = display.newText(sceneGroup, "Điểm : " .. score, _S.CX  * 0.9, _S.CY * 1.8, "iCiel Crocante", 40)
    scoreBar:setFillColor(64 / 255, 134 / 255, 244 / 255)
    star = display.newImageRect(sceneGroup,"assets/img/MusicGame/game/star.png",40,40)
    star.x = _S.CX * 1.5;
	star.y = _S.CY * 1.8;
    -----Question-----
    questionText = display.newText(sceneGroup, "Đâu là con :", _S.CX, _S.CY * 0.3, "iCiel Crocante", 20)
    questionTextLine2 = display.newText(sceneGroup, randomAnimal .. "?", _S.CX, _S.CY * 0.4, "iCiel Crocante", 20)
    questionText:setFillColor(64 / 255, 134 / 255, 244 / 255)
    questionTextLine2:setFillColor(64 / 255, 134 / 255, 244 / 255)
    question = display.newImageRect(sceneGroup, "assets/img/MusicGame/game/tutor.png", 400, 400)
    question.x = _S.CX
    question.y = _S.CY + (_S.T * 0.5)
    question.alpha = 0
    answerHideRight = display.newImageRect(sceneGroup, animalAnswerSheet, rightAnswer, 400, 400)
    answerHideRight:scale(0.4, 0.4)
    answerHideRight.x = _S.CX
    answerHideRight.y = _S.CY + (_S.T * 0.5)
    answerHideRight.alpha = 0
    answerHideWrong = display.newImageRect(sceneGroup, animalAnswerSheet, wrongAnswer, 400, 400)
    answerHideWrong:scale(0.4, 0.4)
    answerHideWrong.x = _S.CX
    answerHideWrong.y = _S.CY + (_S.T * 0.5)
    answerHideWrong.alpha = 0

    ----Timer-------
    lifebarBoxes = display.newImageRect(sceneGroup, "assets/img/MusicGame/game/lifebar_boxes.png", 550, 70)
    lifebarBoxes:scale(0.4, 0.4)
    lifebarBoxes.x = _S.CX
    lifebarBoxes.y = _S.CY + _S.CY * 0.5
    audio.play(gameSound, {channel = 2})
    timerBar = display.newRoundedRect(sceneGroup, 0, 0, 200, 55, 20)
    timerBar:scale(0.8, 0.5)
    timerBar:setFillColor(1, 0, 0)
    timerBar.anchorX = 0
    timerBar.x = _S.CX - _S.CX * 0.65
    timerBar.y = _S.CY + _S.CY * 0.5

    clock = display.newImageRect(sceneGroup, "assets/img/MusicGame/game/clock.png", 50,50)
    clock.x = _S.CX - _S.CX * 0.6
    clock.y = _S.CY + _S.CY * 0.5

    btn_returnToMenu =
		widget.newButton(
		{
			width = 150,
			height = 70,
			defaultFile = "assets/img/MusicGame/game/menu.png",
			overFile = "assets/img/MusicGame/game/menu-pressed.png",
			fontSize = 40,
			onEvent = onBackTouch
		}
	)
	btn_returnToMenu.x = _S.CX
    btn_returnToMenu.y = _S.CY * 1.8
    btn_returnToMenu.alpha = 0
	sceneGroup:insert(btn_returnToMenu)

    ---------BTN 1------------------
    btn_choice =
        widget.newButton(
        {
            -- add the play button
            width = 300,
            height = 300,
            sheet = animalSheet,
            id = "answer",
            defaultFrame = arrayAnswer[1],
            overFrame = arrayAnswer[1] + 1,
            defaultFile = "assets/img/MusicGame/game/button.png",
            overFile = "assets/img/MusicGame/game/button-press.png",
            onEvent = onCheckAnswer
        }
    )
    btn_choice.answer = arrayAnswer[1]
    btn_choice.x = _S.CX * 0.6
    btn_choice.y = question.y
    btn_choice.alpha = 1
    btn_choice:scale(0.4, 0.4)
    sceneGroup:insert(btn_choice)

    --------------end btn1-----------
    ---------BTN 2------------------
    btn_choice2 =
        widget.newButton(
        {
            -- add the play button
            width = 300,
            height = 300,
            sheet = animalSheet,
            id = "answer",
            defaultFrame = arrayAnswer[2],
            overFrame = arrayAnswer[2] + 1,
            defaultFile = "assets/img/MusicGame/game/button.png",
            overFile = "assets/img/MusicGame/game/button-press.png",
            onEvent = onCheckAnswer
        }
    )
    btn_choice2.answer = arrayAnswer[2]
    btn_choice2.x = _S.CX * 1.4
    btn_choice2.y = question.y
    btn_choice2.alpha = 1
    btn_choice2:scale(0.4, 0.4)
    sceneGroup:insert(btn_choice2)

    --------------end btn2-----------
end

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif (phase == "did") then
        tmr_moveTimerBar = timer.performWithDelay(25, moveTimerBar, 0) -- Start the timer
    end
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
    composer.removeScene("menu")
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

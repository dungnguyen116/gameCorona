local composer = require("composer")
local widget = require("widget")
local scene = composer.newScene()

local json = require("json")

local scoresTable = {}

local filePath = system.pathForFile("music-scores.json", system.DocumentsDirectory)

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

local function loadScores()
	local file = io.open(filePath, "r")

	if file then
		local contents = file:read("*a")
		io.close(file)
		scoresTable = json.decode(contents)
	end

	if (scoresTable == nil or #scoresTable == 0) then
		scoresTable = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	end
end

local function saveScores()
	for i = #scoresTable, 11, -1 do
		table.remove(scoresTable, i)
	end

	local file = io.open(filePath, "w")

	if file then
		file:write(json.encode(scoresTable))
		io.close(file)
	end
end
local function gotoMenu(event) -- Return the player to the menu
	if ("ended" == event.phase) then
		composer.gotoScene("MusicGame.scenes.menuD", {time = 500, effect = "crossFade"})
	end
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	-- Load the previous scores
	loadScores()

	-- Insert the saved score from the last game into the table, then reset it
	table.insert(scoresTable, composer.getVariable("finalScore"))
	composer.setVariable("finalScore", 0)

	-- Sort the table entries from highest to lowest
	local function compare(a, b)
		return a > b
	end
	table.sort(scoresTable, compare)

	-- Save the scores
	saveScores()

	local background = display.newImageRect(sceneGroup, "assets/img/MusicGame/game/gamebackground.png", 300, 500)
	background.x = _S.CX
	background.y = _S.CY

	local highScoresHeader = display.newText(sceneGroup, "Điểm Cao", _S.CX, _S.CY * 0.3, "iCiel Crocante", 25)
	highScoresHeader:setFillColor(64 / 255, 134 / 255, 244 / 255)
	for i = 1, 10 do
		if (scoresTable[i]) then
			local yPos = _S.CY * 0.3 + (i * 30)
			local rankNum = display.newText(sceneGroup, i .. ")", _S.CX * 0.8, yPos, "iCiel Crocante", 25)
			rankNum:setFillColor(0)
			rankNum.anchorX = 1

			local thisScore = display.newText(sceneGroup, scoresTable[i], _S.CX, yPos, "iCiel Crocante", 20)
			thisScore:setFillColor(0)
			thisScore.anchorX = 0

			local star = display.newImageRect(sceneGroup, "assets/img/MusicGame/game/star.png", 20, 20)
			star.x = _S.CX * 1.3
			star.y = yPos
		end
	end

	local btn_returnToMenu =
		widget.newButton(
		{
			width = 150,
			height = 70,
			defaultFile = "assets/img/MusicGame/game/menu.png",
			overFile = "assets/img/MusicGame/game/menu-pressed.png",
			fontSize = 40,
			onEvent = gotoMenu
		}
	)
	btn_returnToMenu.x = _S.CX
	btn_returnToMenu.y = _S.CY * 1.8
	sceneGroup:insert(btn_returnToMenu)
	--local menuButton = display.newText( sceneGroup, "Menu", display.contentCenterX, 810, native.systemFont, 44 )
	--menuButton:setFillColor( 0.75, 0.78, 1 )
	--menuButton:addEventListener( "tap", gotoMenu )
end

-- show()
function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase

	if (phase == "will") then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
	elseif (phase == "did") then
	-- Code here runs when the scene is entirely on screen
	end
end

-- hide()
function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase

	if (phase == "will") then
		-- Code here runs when the scene is on screen (but is about to go off screen)
	elseif (phase == "did") then
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

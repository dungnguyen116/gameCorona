local composer = require( "composer" )
local widget = require("widget");
local scene = composer.newScene()
local json = require( "json" )

local scoresTable = {}

local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )
local function rotateObject90d(object)
	object:rotate(90)
end

local function rotateImg90d(img)
	img.rotation = 90;
end

local function loadScores()

	local file = io.open( filePath, "r" )

	if file then
		local contents = file:read( "*a" )
		io.close( file )
		scoresTable = json.decode( contents )
	end

	if ( scoresTable == nil or #scoresTable == 0 ) then
		scoresTable = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	end
end

local function saveScores()

	for i = #scoresTable, 11, -1 do -- !!!
		table.remove( scoresTable, i )
	end

	local file = io.open( filePath, "w" )

	if file then
		file:write( json.encode( scoresTable ) )
		io.close( file )
	end
end

local function gotoMenu()
	composer.gotoScene( "AnimalImg.menuv", { time=800, effect="crossFade" } )
end

local function HandleHomeButton(event)
	if(event.phase == "ended") then	
		gotoMenu();
	end
end

local function rotateObj(object)
    transition.to(object, {
        --rotation = 0.5,
        x = object.x + 2,
        time = 700,
        onComplete = function ()
            transition.to(object, { 
                --rotation = -0.5,
                x = object.x - 2,
                time = 700,
                onComplete = function ()
                    rotateObj(object);
                end
            })
        end
    })
end
-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	-- Load the previous scores
	loadScores()

	local function compare( a, b )
		return a > b
	end
	table.sort( scoresTable, compare )
	
	saveScores();

	local background = display.newImageRect(sceneGroup, "assets/img/AnimalImg/menu/backgroundZun.png", 300, 500)
    background.x = display.contentCenterX
    background.y = display.contentCenterY	

	local highScoresHeader = display.newText( sceneGroup, "Bảng Xếp Hạng", display.contentCenterX + (display.contentCenterX * 0.7), display.contentCenterY, "AnimalImg/iCiel-Crocante", 30 )
	highScoresHeader:setFillColor(7/255, 0/255, 138/255);
	rotateObject90d(highScoresHeader);
	for i = 1, 4 do -- index = 10 is used for processing gaming.(saving scores while gaming)
		if ( scoresTable[i] ) then
			local xPos = 250 - ( i * 25 )
			local rankNum = display.newText( sceneGroup, i .. ")",xPos , display.contentCenterY - 20, "AnimalImg/iCiel-Crocante", 20 )
			rankNum.anchorX = 1
			rankNum:setFillColor(32/255, 31/255, 31/255);
			rotateObject90d(rankNum);
			local thisScore = display.newText( sceneGroup, scoresTable[i] ,xPos , display.contentCenterY,"AnimalImg/iCiel-Crocante", 20 )
			thisScore.anchorX = 0;
			thisScore:setFillColor(0.19, 0.52, 0.15);
			rotateObject90d(thisScore);
		end
	end

	local menuButton = widget.newButton({
		width = 100, 
		height = 100,
		defaultFile = "assets/img/AnimalImg/game/backButtonCopy.png",
		overFile = "assets/img/AnimalImg/game/backButtonCopyCopy.png",
		onEvent = HandleHomeButton
	})
	
	menuButton.x = display.contentCenterX - (display.contentCenterX * 0.5);
	menuButton.y = display.contentCenterY;
	sceneGroup:insert(menuButton);
	rotateObj(menuButton);
	rotateImg90d(menuButton);
end
-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		-- Start the music!
	end
end
-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		-- Stop the music!
		composer.removeScene( "highScore" )
	end
end
-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	-- Dispose audio!
	composer.setVariable( "finalScore", 0 )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene

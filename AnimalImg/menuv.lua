local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local loadAnimal;
local loopGame;
local bgSoundPlay;
local sceneGroup; 

local bgSound = audio.loadStream( "assets/audio/AnimalImg/Despacito.wav" );
audio.setVolume(0.2, {channel = 3});
bgSoundPlay = audio.play( bgSound ,{ channel=3, loops=-1, fadein=2000 }) 

composer.setVariable("bgSound", bgSound);

local function gotoGame()
	composer.gotoScene( "AnimalImg.maingame", { time=800, effect="crossFade" } )
end

local function gotoHighScores()
	composer.gotoScene( "AnimalImg.highScorev", { time=800, effect="crossFade" } )
end

local function gotoMainMenu()
	audio.stop(bgSoundPlay);
	bgSoundPlay = nil;	
	local backgroundSound = composer.getVariable("backgroundSound")
    audio.play(backgroundSound);
	composer.gotoScene( "menu-game", { time=800, effect="crossFade" } )
end

local function rotateObject90d(object)
	object:rotate(90)
end

local function rotateImg90d(img)
	img.rotation = 90;
end

local function handleNextButtonEvent(event) 
	if("ended" == event.phase) then
		display.remove(loadAnimal);
		gotoGame();
	end
end

local function handleBackToMenuEvent(event) 
	if("ended" == event.phase) then
		display.remove(loadAnimal);
		--audio.stop();
		gotoMainMenu();
	end
end

local function handleHighScoreEvent(event)
	if("ended" == event.phase)then
		display.remove(loadAnimal);
		gotoHighScores();
	end
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

local function spriteImage(animalName, timeLoop, widthImg, heighImg, numFrames, animalLoad) 
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
	
	loadAnimal = display.newSprite(sceneGroup, sheet, sequence);
	
	rotateImg90d(loadAnimal);
	loadAnimal:scale( 0.4, 0.4 )
	if(animalLoad == "pig") then
		loadAnimal.x = display.contentCenterX;
		loadAnimal.y = -40;
		
		loadAnimal:setSequence("sprite");
		loadAnimal:play();
		
		transition.to(loadAnimal, {
			y = display.contentHeight + 50,
			time = 5000,
			onComplete = function() 
				display.remove(loadAnimal);
				--composer.gotoScene( "menu", { time=800, effect="crossFade" } )
			end
		})
	else
		loadAnimal.x = display.contentCenterX
		loadAnimal.y = display.contentHeight + 50;
		loadAnimal:setSequence("sprite");
		loadAnimal:play();
		
		transition.to(loadAnimal, {
			y = -50,
			time = 5000,
			onComplete = function() 
				display.remove(loadAnimal);
				--composer.gotoScene( "menu", { time=800, effect="crossFade" } )
			end
		})
	end
	
end

local function rdLoadAnimal() 
	local rd = math.random(2);
	if(rd == 1) then
		spriteImage("assets/img/AnimalImg/sprite/runningPig.png",500, 300, 300, 20, "pig");-- pig
	else
		spriteImage("assets/img/AnimalImg/sprite/runningDog.png",500, 288, 288, 6, "dog");-- dog
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
	
	sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	
	local background = display.newImageRect( sceneGroup, "assets/img/AnimalImg/menu/backgroundZun.png", 300, 500 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local logo = display.newImageRect(sceneGroup, "assets/img/AnimalImg/menu/logo.png", 250, 125);
	logo.x = display.contentWidth - 85;
	logo.y = display.contentCenterY;
	rotateImg90d(logo);
	rotateObj(logo);
	local backButton = widget.newButton({
		width = 50,
		height = 50,
		defaultFile = "assets/img/AnimalImg/menu/backMenuCopy.png",
		overFile = "assets/img/AnimalImg/menu/backMenu.png",
		onEvent = handleBackToMenuEvent
	})
	backButton.x = display.contentWidth - 60;
	backButton.y = 40;
	sceneGroup:insert(backButton);
	
	rotateObject90d(backButton);
	moveObject(backButton);
	
	
	
	local startButton = widget.newButton({
		width = 70,
		height = 70,
		defaultFile = "assets/img/AnimalImg/menu/nextButton.png",
		overFile = "assets/img/AnimalImg/menu/nextButtonCopy.png",
		onEvent = handleNextButtonEvent
	})
	startButton.x = 70;
	startButton.y = display.contentCenterY - (display.contentCenterY * 0.5)
	sceneGroup:insert(startButton);
	rotateObject90d(startButton);
	
	moveObject(startButton);
	
	local highScoreButton = widget.newButton({
		width = 120,
		height = 75,
		defaultFile = "assets/img/AnimalImg/menu/highscore.png",
		overFile = "assets/img/AnimalImg/menu/highscoreCopy.png",
		onEvent = handleHighScoreEvent
	})
	highScoreButton.x = 70;
	highScoreButton.y = display.contentCenterY + (display.contentCenterY * 0.5);
	sceneGroup:insert(highScoreButton)
	rotateObject90d(highScoreButton);
	
	moveObject(highScoreButton);
	
	composer.setVariable( "finalScore", 0 )
end
-- show() 
function scene:show( event ) 
	
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		-- Start the music!
		local isChannel1Playing = audio.isChannelPlaying(3);
		if isChannel1Playing then
		elseif(isChannel1Playing == false) then
			local bgSound = audio.loadStream( "AnimalImg/audio/Despacito.wav" );
			audio.setVolume(1, {channel=3});
			bgSoundPlay = audio.play( bgSound ,{ channel=3, loops=-1, fadein=2000 })
				
			composer.setVariable("bgSound", bgSound);
		end
		
		rdLoadAnimal();
		loopGame = timer.performWithDelay(6000, rdLoadAnimal, 0);
	end
end
-- hide() 
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel(loopGame);
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		-- Stop the music!
		composer.removeScene("menuv")
	end
end
-- destroy () 
function scene:destroy(event) 
end

scene:addEventListener("create", scene);
scene:addEventListener("show", scene);
scene:addEventListener("hide", scene);
scene:addEventListener("destroy", scene);

return scene;

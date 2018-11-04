local composer = require("composer");
local scene = composer.newScene();
local widget = require("widget");
local animal;
local rdNumber = math.random(3);
local bgSound = composer.getVariable("bgSound");

local function startAgain() 
	display.remove(animal);
	audio.resume(bgSound);
	composer.gotoScene("AnimalImg.menuv", { time=800, effect="crossFade" });
end

local function rotateObject90d(object)
	object:rotate(90)
end

local function rotateImg90d(img)
	img.rotation = 90;
end

local function spriteImage(sceneGroup, animalName, timeLoop, widthImg, heighImg, numFrames) 
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
	animal = display.newSprite(sceneGroup, sheet, sequence);
	rotateImg90d(animal);
	animal:scale(0.4, 0.4);
	animal.x = display.contentCenterX;
	animal.y = display.contentCenterY;
	animal:setSequence("sprite");
	animal:play();
	
	timer.performWithDelay( 3000, startAgain );
	
end

function scene:create(event) 
	local sceneGroup = self.view;
	audio.pause(bgSound);
	local loseSound = audio.loadSound( "AnimalImg/audio/ble.wav" );
	audio.setVolume( 0.7 , {channel=5})
	audio.play( loseSound, {channel=5} );
	
	local background = display.newImageRect(sceneGroup, "assets/img/AnimalImg/menu/backgroundZun.png", 300, 500)
    background.x = display.contentCenterX
    background.y = display.contentCenterY;
	
	local resultLose = composer.getVariable("lose");
	local result;
	if(resultLose == 0) then
		result = display.newText(sceneGroup, "Sai rồi bé ơi", display.contentCenterX + 100, display.contentCenterY, "AnimalImg/iCiel-Crocante", 23);
	else
		result = display.newText(sceneGroup, "Hết giờ", display.contentCenterX + 100, display.contentCenterY, "AnimalImg/iCiel-Crocante", 30);
	end
	rotateObject90d(result);
	result:setFillColor(0.19, 0.52, 0.15);
	if(rdNumber == 1) then
		spriteImage(sceneGroup,"assets/img/AnimalImg/sprite/dogcry.png",1000, 288, 288, 9);-- dog
	elseif(rdNumber == 2) then
		spriteImage(sceneGroup,"assets/img/AnimalImg/sprite/wrongAnswer.png",500, 288, 288, 2);-- bird
	else
		spriteImage(sceneGroup,"assets/img/AnimalImg/sprite/chickendrop.png",1000, 318, 318, 20);-- pig
	end
	
end

function scene:show(event)
	print("show")
end

function scene:hide(event)
	local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        --timer.cancel( gameLoopTimer )
 
    elseif ( phase == "did" ) then
        audio.stop(5); 
        composer.removeScene( "AnimalImg.lose" )
    end
end

function scene:destroy(event)
	local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    -- Dispose audio!
	print("destroy win: ");
    audio.dispose( loseSound )
end

scene:addEventListener("create", scene);
scene:addEventListener("show", scene);
scene:addEventListener("hide", scene);
scene:addEventListener("destroy", scene);

return scene;
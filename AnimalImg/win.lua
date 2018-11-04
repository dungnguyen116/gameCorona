local composer = require("composer");
local scene = composer.newScene();
local win;
local bgSound = composer.getVariable("bgSound");
local destinyRandom = composer.getVariable("answer");
math.randomseed(os.time())
local filePath = "";
local name;

local animalName = { "Con Khỉ", "Con Gà", "Hươu Cao Cổ", "Chim Bồ Câu", "Con Chó", "Con Tê Giác", "Con Sư Tử", "Con Hổ"
, "Con Bướm", "Con Ong", "Con Cáo", "Con Cá Heo", "Con Ngựa", "Con Voi", "Con Gấu", "Con Bò" };

local rightAnswer = animalName[destinyRandom];

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

for row in db:nrows("SELECT * FROM tblWinSound where id = " .. destinyRandom  ) do
	filePath = row.content;
end

local winSound = audio.loadSound( filePath );

local function startAgain() 
	display.remove(win);
	audio.resume(bgSound);
	composer.gotoScene("AnimalImg.maingame");
end

local function rotateObject90d(object)
	object:rotate(90)
end

local function rotateImg90d(img)
	img.rotation = 90;
end	
								  
local function spriteImage(sceneGroup, animalName, timeLoop, widthImg, heighImg, numFrames, posX, posY) 
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
	win = display.newSprite(sceneGroup, sheet, sequence);
	win:scale(0.4, 0.4);
	rotateImg90d(win);			   
	win.x = posX;
	win.y = posY;
	win:setSequence("sprite");
	win:play();
	
	timer.performWithDelay( 4000, startAgain );
	
end

local detectCoordinates = {
	frames = {
        {
            -- 1
            x = 0,
            y = 0,
            width = 250,
            height = 250
        },
        {--2
            x = 250,
            y = 0,
            width = 250,
            height = 250
        },
        {
            -- 3
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
            -- 4
            x = 1000,
            y = 0,
            width = 250,
            height = 250
        },
        {--5
            x = 1250,
            y = 0,
            width = 250,
            height = 250
        },
        {
            -- 6
            x = 1500,
            y = 0,
            width = 250,
            height = 250
        },
        {--7
            x = 1750,
            y = 0,
            width = 250,
            height = 250
        },
        {
            -- 8
            x = 0,
            y = 250,
            width = 250,
            height = 250
        },
        {--9
            x = 250,
            y = 250,
            width = 250,
            height = 250
        },
        {
            -- 10
            x = 500,
            y = 250,
            width = 250,
            height = 250
        },
        {--11
            x = 750,
            y = 250,
            width = 250,
            height = 250
        },
        {
            -- 12
            x = 1000,
            y = 250,
            width = 250,
            height = 250
        },
        { --13
            x = 1250,
            y = 250,
            width = 250,
            height = 250
        },
        {
            -- 14
            x = 1500,
            y = 250,
            width = 250,
            height = 250
        },
        {--15
            x = 1750,
            y = 250,
            width = 250,
            height = 250
        },
        {
            -- 16
            x = 0,
            y = 500,
            width = 250,
            height = 250
        }	
	}
}

function scene:create(event) 
	local sceneGroup = self.view;
	audio.pause(bgSound);
	
	--local rdNumber = 2; -- number animal in win type
	local background = display.newImageRect(sceneGroup, "assets/img/AnimalImg/menu/backgroundZun.png", 300, 500)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
	
	local rdNumber = math.random(4); -- number animal in win type
	if(rdNumber == 1) then
		spriteImage(sceneGroup, "assets/img/AnimalImg/sprite/runningPig.png",500, 300, 300, 20, 
			display.contentCenterX - (display.contentCenterX * 0.5), display.contentCenterY - 150);-- pig
	elseif(rdNumber == 2) then
		spriteImage(sceneGroup, "assets/img/AnimalImg/sprite/runningDog.png",600, 288, 288, 6, 
			display.contentCenterX - (display.contentCenterX * 0.5), display.contentCenterY - 150);
	elseif(rdNumber == 3) then
		spriteImage(sceneGroup, "assets/img/AnimalImg/sprite/dogfun.png",1000, 288, 288, 10, 
			display.contentCenterX - (display.contentCenterX * 0.5), display.contentCenterY - 150);
	else
		spriteImage(sceneGroup, "assets/img/AnimalImg/sprite/chickefun.png",2000, 318, 318, 20, 
			display.contentCenterX - (display.contentCenterX * 0.5), display.contentCenterY - 150);
	end
	
	local destinyRandom = composer.getVariable("answer");
	
	local score = composer.getVariable("score");
	
	scoreText = display.newText(sceneGroup, score, display.contentCenterX + (display.contentCenterX * 0.75), display.contentCenterY, "AnimalImg/iCiel-Crocante", 30);
	scoreText:setFillColor(58/255, 69/255, 239/255);
	
	rotateObject90d(scoreText);
	
	local result
	result = display.newText(sceneGroup, rightAnswer, display.contentCenterX - (display.contentCenterX * 0.7), display.contentCenterY,"AnimalImg/iCiel-Crocante", 30 )
	
	rotateObject90d(result);			 
	
	audio.setVolume( 0.7 , {channel=2})
	audio.play( winSound, {channel=2} );
	audio.reserveChannels( 2 )
	
	result:setFillColor(6/255, 17/255, 182/255);
	
	local animalAnswerList = graphics.newImageSheet("assets/img/AnimalImg/game/animalAnswer.png", detectCoordinates);
	local animalAnswer = display.newImageRect( sceneGroup, animalAnswerList, destinyRandom, 250 , 250); 
	animalAnswer:scale(0.6, 0.6);
	
	animalAnswer.x = display.contentCenterX;
	animalAnswer.y = display.contentCenterY;
	
	rotateImg90d(animalAnswer);			
end

function scene:show(event) 
	local sceneGroup = self.view;
	local phase = event.phase;
	if("will" == phase) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
	elseif("did") then
		-- Code here runs when the scene is entirely on screen
		
	end
end

function scene:hide(event) 
	local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        --timer.cancel( gameLoopTimer )
    elseif ( phase == "did" ) then
		print("win hide: ")
        
		local isChannel2Playing = audio.isChannelPlaying(2);
		if isChannel4Playing then
			audio.stop( 2 );
		elseif(isChannel4Playing == false) then
			audio.stop( 2 );
		end
		audio.stop( 2 );
		composer.removeScene( "AnimalImg.win" )
    end
end

function scene:destroy(event) 
	local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    -- Dispose audio!
	local isChannel2Playing = audio.isChannelPlaying(2);
	if isChannel4Playing then
		audio.stop( 2 );
		audio.dispose( winSound )
	elseif(isChannel4Playing == false) then
		audio.dispose( winSound )
	end
end

scene:addEventListener("create", scene);
scene:addEventListener("show", scene);
scene:addEventListener("hide", scene);
scene:addEventListener("destroy", scene);

return scene;

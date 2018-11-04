local composer = require("composer");
local scene = composer.newScene();
local widget = require( "widget" )
local physics = require("physics");
local widget = require( "widget" )
physics.start();
physics.setGravity(0,0); 				-- set every object that set physics, stop dropping
local backGroup
local mainGroup
local uiGroup
local destinyRandom;					-- random a number
local animalQuestion;					-- animal hidden. animal question
local animalAnswer = {};				-- list animal answers
local gameLoopTimer;					-- loop to check whether the animal answers out of range or not.
local isDragAllowed = true;  -- create a flag or a variable
local scoreText;
local arrayRandom = {};
local scoreText;
local score = 0
local json = require( "json" )
local scoresTable = {}
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )
local isMatched = false;
local initX;
local initY;
local initFlag = false;
local stObject = "";
local ndObject;

local function rotateObj(object)
    transition.to(object, {
        rotation = 0.5,
        y = object.y + 0.5,
        time = 700,
        onComplete = function ()
            transition.to(object, { 
                rotation = -0.5,
                y = object.y - 0.5,
                time = 700,
                onComplete = function ()
                    rotateObj(object);
                end
            })
        end
    })
end

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

	for i = #scoresTable, 11, -1 do
		table.remove( scoresTable, i )
	end

	local file = io.open( filePath, "w" )

	if file then
		file:write( json.encode( scoresTable ) ) 
		io.close( file ) 
	end
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

local animalQuestionList = graphics.newImageSheet("assets/img/AnimalImg/game/animalQuestion.png", detectCoordinates);

local animalAnswerList = graphics.newImageSheet("assets/img/AnimalImg/game/animalAnswer.png", detectCoordinates);

local function randomDestinyObject() 
	animalQuestion = display.newImageRect( mainGroup, animalQuestionList, destinyRandom, 250, 250 ) 
	animalQuestion:scale(0.5, 0.5);
	animalQuestion.myName = "question"..destinyRandom; 								-- set name of animal question
	rotateImg90d(animalQuestion);
	animalQuestion.x = display.contentCenterX;
	animalQuestion.y = display.contentCenterY - (display.contentCenterY * 0.4);
	physics.addBody(animalQuestion, {radius = 30});
end

local function checkMatched(animal)
	if(isMatched == false) then
		transition.to(animal, {
			time = 500,
			x = initX,
			y = initY,
			onComplete = function()
			end
		})
	end
end				  

local function dragAnimal(event)						-- function called when drag an object 
	local phase = event.phase;
	local animal = event.target;
	local isEnded = false;
	ndObject = animal.myName;
	
	if(initFlag == false or stObject ~= ndObject) then
	-- store init position
		stObject = animal.myName;
		initX = animal.x;
		initY = animal.y;
		initFlag = true;
	end
	if(phase == "began") then
		display.currentStage:setFocus(animal);
		animal.touchOffsetX = event.x - animal.x;
		animal.touchOffsetY = event.y - animal.y;
		
	elseif(phase == "moved" and isDragAllowed == true) then
		if(animal.touchOffsetX == nil) then
			return
		end
		
        --animal.x = event.x - animal.touchOffsetX; 
		animal.y = event.y - animal.touchOffsetY;
		animal.x = event.x - animal.touchOffsetX
		
		
		
		--print("event: " .. event.x);
		--print("touch: " .. animal.touchOffsetX);
		--animal.y = event.y - animal.touchOffsetY;
	elseif (phase == "ended" or phase == "cancelled") then
		isEnded = true;		 
		-- Release touch focus on the animal
        display.currentStage:setFocus( nil );
		if(isEnded) then
			checkMatched(animal);
		end		 
	end
	return true;
end

local function randomAnswers()
	flag = true;
	for i = 1, 16, 1 do 		-- init array
		arrayRandom[i] = i;
	end
	
	for i = 1, 16, 1 do	 	-- suffle array
		local random1 = math.random(16)
		local random2 = math.random(16)
		arrayRandom[random1], arrayRandom[random2] = arrayRandom[random2], arrayRandom[random1]
	end
	
	for i = 1, 4, 1 do 		-- check the suffle whether exist the answer or not.
		if (arrayRandom[i] == destinyRandom) then 
		-- visit all element and detect whether the suffle array have the answer or not
			flag = true;
			break;
		else
			flag = false;
		end
	end
	
	if(flag == false) then 	-- if the answer isnot exist in array answer, so random a position to add the answer
		arrayRandom[math.random(1,4)] = destinyRandom;
	end
	
	for i = 1, 4, 1 do		-- display the answers
		
		animalAnswer[i] = display.newImageRect( mainGroup, animalAnswerList, arrayRandom[i], 250 , 250 ); 
		animalAnswer[i]:scale(0.5, 0.5);
		if(i % 2 == 0)then
			animalAnswer[i].x = display.contentWidth - (display.contentWidth * 0.3);
			animalAnswer[i].y = display.contentCenterY + (i * 57) - 57;
		else 
			animalAnswer[i].x = 90;									-- set position of animal answer
			animalAnswer[i].y =  display.contentCenterY + (i * 57);
		end
		
		rotateImg90d(animalAnswer[i]);
		animalAnswer[i].myName = "answer"..arrayRandom[i];						-- set name of animal answer
		
		physics.addBody(animalAnswer[i], "dynamic", {radius = 30, isSensor=true})
		animalAnswer[i]:setLinearVelocity(0, 0)
		animalAnswer[i]:addEventListener( "touch", dragAnimal) -- set touch event for answer
		
	end
	
end

local function gotoNextScene(sceneName) 
	isDragAllowed = true;
	composer.setVariable( "finalScore", score );
	
	for i = #animalAnswer, 1, -1 do
		display.remove( animalAnswer[i] )
		table.remove( animalAnswer, i )
	end
	display.remove(animalQuestion); 			-- This thing is fucking important
	--Runtime:removeEventListener("collision", onCollision)
	--saveScores();
	composer.removeScene("AnimalImg.maingame")
	composer.gotoScene(sceneName, { time=1500, effect="crossFade" });
end

local function removeAnimalAnswer()
	for i = #animalAnswer, 1, -1 do
		local animalAns = animalAnswer[i];
		if (animalAns.y > display.contentHeight + 90) then
			display.remove( animalAns )
			table.remove( animalAnswer, i )
			if(#animalAnswer == 0) then
				composer.setVariable("lose", 1); -- 1 is overtime
				gotoNextScene("AnimalImg.lose");
			end
		end
	end
end

local function gotoMenu(event)
	print("score " .. score);
	local flag = false;
	for i = 1, #scoresTable - 1 do
		if (scoresTable[i] == 0) then
			scoresTable[i] = score;
			flag = true;
			break;
		end
	end
	if(flag == false) then
		scoresTable[9] = score;
	end
	scoresTable[10] = 0; -- reset
	saveScores();
	for i = #animalAnswer, 1, -1 do
		display.remove( animalAnswer[i] )
		table.remove( animalAnswer, i )
	end
	display.remove(animalQuestion); 			-- This thing is fucking important
	--Runtime:removeEventListener("collision", onCollision)
	composer.removeScene("AnimalImg.maingame");
	--Later, transition to the hidden scene (no loading necessary)
	composer.gotoScene( "AnimalImg.menuv" ) 
end 

local function displayCorrectResult(destinyRandom) 	-- find somehow to connect to DB 
	
	
	isDragAllowed = false;
	
	score = score + 100;
	scoreText.text = score;	-- display next button.
	
	scoresTable[10] = score; 	--save score at position = 10;
	
	saveScores();
	
	composer.setVariable("answer", destinyRandom); -- number of animal answer;
	composer.setVariable("score", score);
	composer.removeScene( "AnimalImg.maingame" ) 
	gotoNextScene("AnimalImg.win");
end

local function onCollision(event) 
	local obj1 = event.object1;
	local obj2 = event.object2;
	
	if(event.phase == "began") then
		local obj1 = event.object1;
		local obj2 = event.object2;
		
		if( obj1.myName:sub(0, 6) == obj2.myName:sub(0, 6) ) then
			print(obj1.myName:sub(0, 6));
			return;
		end
		
		if ( obj1.myName:sub(9) == obj2.myName:sub(7)) then
			isMatched = true; 
			isDragAllowed = false;
			transition.to(obj2, {
				time = 1000,
				x = obj1.x;
				y = obj1.y;
				
				onComplete = function() 
					
					display.remove( obj1 )
					displayCorrectResult(destinyRandom);
			
					physics.pause(); -- stop dropping
				end
			})
		else
			composer.setVariable("lose", 0); -- 0 is wrong match
			gotoNextScene("AnimalImg.lose");
			physics.pause(); -- stop dropping
		end
		
	end
	
	composer.loadScene( "AnimalImg.menuv")
	
end

local function handleMenuButtonEvent(event)
 
    if ( "ended" == event.phase ) then
        gotoMenu();
    end
end
-- create() 
function scene:create(event)
	destinyRandom = math.random(16);
	
	local sceneGroup = self.view

	-- Set up display groups
	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup )  -- Insert into the scene's view group

	mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
	sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert( uiGroup )    -- Insert into the scene's view group
	
	local background = display.newImageRect(backGroup, "assets/img/AnimalImg/menu/backgroundZun.png", 300, 500)
    background.x = display.contentCenterX
    background.y = display.contentCenterY	
	
	loadScores(); 
	
	table.insert(scoresTable, composer.getVariable("finalScore") );
	
	score = scoresTable[10]; -- first is 0
	scoreText = display.newText(uiGroup, score, display.contentCenterX, -100, native.systemFont, 50);
	scoreText:setFillColor(0);
	
	local menuButton = widget.newButton({
        width = 70,
        height = 70,
        defaultFile = "assets/img/AnimalImg/game/backButtonCopy.png",
        overFile = "assets/img/AnimalImg/game/backButtonCopyCopy.png",
        onEvent = handleMenuButtonEvent
		}
	)
	menuButton.x = display.contentWidth - (display.contentWidth * 0.2);
	menuButton.y = 50;
	uiGroup:insert(menuButton);
	
	
	rotateObject90d(menuButton);
	randomDestinyObject();
	-- load answers
	randomAnswers();
	
end
-- show() 
function scene:show(event)
	print("show maingame")
	local sceneGroup  = self.view;
	sceneGroup:insert(uiGroup);
	local phase = event.phase;
	if(phase == "will") then
	elseif(phase == "did") then
		--physics.start()
		Runtime:addEventListener( "collision", onCollision )
		gameLoopTimer = timer.performWithDelay( 500, removeAnimalAnswer, 0 )
	end
end
-- hide() 
function scene:hide(event)

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		-- timer.cancel( gameLoopTimer )

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		--Runtime:removeEventListener( "collision", onCollision )
		--physics.pause()
		--Stop the music
		composer.removeScene( "AnimalImg.maingame" ) 
		
	end
end
-- destroy() 
function scene:destroy(event)
	local sceneGroup = self.view
	Runtime:removeEventListener("collision", onCollision);
	
	print("destroy maingame")
end

scene:addEventListener("create", scene);
scene:addEventListener("show", scene);
scene:addEventListener("hide", scene);
scene:addEventListener("destroy", scene);

return scene;


local composer = require("composer");
local scene = composer.newScene();

local pig;
local dog;

local mainGroup = display.newGroup(); -- Display group for the ship, asteroids, lasers, etc.

local typeObject = math.random( 2 ); -- random number

local function runningDog()
	local sequenceDog = {
		name = "dogRun",
		start = 1,
		count = 6,
		time = 500,
		loopDirection = "forward"
	}
	local optionsDog = {
		width = 288,
		height = 288,
		numFrames = 6
	}
	local dogSheet = graphics.newImageSheet("runningDog.png", optionsDog);
	dog = display.newSprite(dogSheet, sequenceDog);
	dog.x = display.contentWidth + 200;
	dog.y = display.contentHeight - 150;
	dog:setSequence("dogRun");
	dog:play();
	
	transition.to(dog, {
		x = -200,
		time = 4000,
		onComplete = function() 
			display.remove(dog);
			composer.gotoScene( "menu", { time=800, effect="crossFade" } )
		end
		})
end

local function runningPig() -- running Pig
	local sequencePig = {{ -- properties of Pig
			name="pigRun", 
			start= 1, 
			count= 20, 
			time=500, 
			loopDirection="forward"
		}
	}
	local optionsPig = {
		width = 300, 
		height = 300, 
		numFrames = 20
	}
	
	local pigSheet = graphics.newImageSheet("runningPig.png", optionsPig)
	pig = display.newSprite(pigSheet,sequencePig)
	pig.x = -100;  					-- set the position x of object 
	pig.y = display.contentHeight - 150; 	-- set the position y of object 
	pig:setSequence("pigRun");
	pig:play();
	
	transition.to(pig, {
		x = display.contentWidth + 300,
		time = 5000,
		onComplete = function() 
			display.remove(pig);
			composer.gotoScene( "menu", { time=800, effect="crossFade" } )
		end
	})
end

function scene:create(event) 
	local groupScene = self.view;
	
	local background = display.newImageRect(groupScene, "another.png", 800, 1400);
	background.x = display.contentCenterX -- if missing this step the position will be 0, 0
	background.y = display.contentCenterY
	
	if(typeObject == 1) then 
		runningPig(); -- pig area
	else
		runningDog(); -- dog area
	end
end


scene:addEventListener("create", scene);
return scene;

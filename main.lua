-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code hered

display.setStatusBar(display.HiddenStatusBar)

math.randomseed(os.time())

local composer = require("composer")

composer.gotoScene("load-menu")
--composer.gotoScene("AnimalImg.maingame");

-- Require the SQLite library
local sqlite3 = require( "sqlite3" )
 
-- Create a file path for the database file "data.db"
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
 
-- Open the database for access
local db = sqlite3.open( path )

-- Creating a Table nameL tblWinSound 
local tblWinSound = [[create table if not exists tblWinSound (id INTEGER PRIMARY KEY autoincrement, name, content); ]]
local tblMusicGame = [[create table if not exists tblMusicGame (id INTEGER PRIMARY KEY autoincrement, name, content); ]]
db:exec(tblWinSound);
local drop = [[DROP TABLE [IF EXISTS] tblMusicGame]]
db:exec(drop);
-- insert data 
local conkhi = [[insert into tblWinSound values(1, 'conkhi', 'assets/audio/AnimalImg/audio/conkhi.wav' ); ]]
db:exec(conkhi);
local conga = [[insert into tblWinSound values(2, 'conga', 'assets/audio/AnimalImg/audio/conga.wav' ); ]]
db:exec(conga);
local conhuoucaoco = [[insert into tblWinSound values(3, 'conhuoucaoco', 'assets/audio/AnimalImg/audio/huoucaoco.wav' ); ]]
db:exec(conhuoucaoco);
local chimbocau = [[insert into tblWinSound values(4, 'chimbocau', 'assets/audio/AnimalImg/audio/chimbocau.wav' ); ]]
db:exec(chimbocau);
local concho = [[insert into tblWinSound values(5, 'concho', 'assets/audio/AnimalImg/audio/concho.wav' ); ]]
db:exec(concho);
local contegiac = [[insert into tblWinSound values(6, 'contegiac', 'assets/audio/AnimalImg/audio/contegiac.wav' ); ]]
db:exec(contegiac);
local consutu = [[insert into tblWinSound values(7, 'consutu', 'assets/audio/AnimalImg/audio/consutu.wav' ); ]]
db:exec(consutu);
local conho = [[insert into tblWinSound values(8, 'conho', 'assets/audio/AnimalImg/audio/conho.wav' ); ]]
db:exec(conho);
local conbuom = [[insert into tblWinSound values(9, 'conbuom', 'assets/audio/AnimalImg/audio/conbuom.wav' ); ]]
db:exec(conbuom);
local conong = [[insert into tblWinSound values(10, 'conong', 'assets/audio/AnimalImg/audio/conong.wav' ); ]]
db:exec(conong);
local concao = [[insert into tblWinSound values(11, 'concao', 'assets/audio/AnimalImg/audio/concao.wav' ); ]]
db:exec(concao);
local concaheo = [[insert into tblWinSound values(12, 'concaheo', 'assets/audio/AnimalImg/audio/concaheo.wav' ); ]]
db:exec(concaheo);
local conngua = [[insert into tblWinSound values(13, 'conngua', 'assets/audio/AnimalImg/audio/conngua.wav' ); ]]
db:exec(conngua);
local convoi = [[insert into tblWinSound values(14, 'convoi', 'assets/audio/assets/audio/AnimalImg/audio/convoi.wav' ); ]]
db:exec(convoi);
local congau = [[insert into tblWinSound values(15, 'congau', 'assets/audio/AnimalImg/audio/congau.wav' ); ]]
db:exec(congau);
local conbo = [[insert into tblWinSound values(16, 'conbo', 'assets/audio/AnimalImg/audio/conbo.wav' ); ]]
db:exec(conbo);
-----Musicgame--------------------------------------------------
local thanlan = [[insert into tblMusicGame values(1, 'thanlan', 'assets/audio/MusicGame/hai-con-than-lan-con.wav' ); ]]
db:exec(thanlan);
local vit = [[insert into tblMusicGame values(2, 'vit', 'assets/audio/MusicGame/mot-con-vit.wav' ); ]]
db:exec(vit);
local caocao = [[insert into tblMusicGame values(3, 'caocao', 'assets/audio/MusicGame/con-cao-cao.wav' ); ]]
db:exec(caocao);
local cavang = [[insert into tblMusicGame values(4, 'cavang', 'assets/audio/MusicGame/ca-vang-boi.wav' ); ]]
db:exec(cavang);
local voi = [[insert into tblMusicGame values(5, 'voi', 'assets/audio/MusicGame/chu-voi-con-o-ban-don.wav' ); ]]
db:exec(voi);
local meo = [[insert into tblMusicGame values(6, 'meo', 'assets/audio/MusicGame/rua-mat-nhu-meo.wav' ); ]]
db:exec(meo);
local ech = [[insert into tblMusicGame values(7, 'ech', 'assets/audio/MusicGame/chu-ech-con.wav' ); ]]
db:exec(ech);
local ga = [[insert into tblMusicGame values(8, 'ga', 'assets/audio/MusicGame/conga.wav' ); ]]
db:exec(ga);
local heo = [[insert into tblMusicGame values(9, 'heo', 'assets/audio/MusicGame/conheo.wav' ); ]]
db:exec(heo);
local thiennga = [[insert into tblMusicGame values(10, 'thiennga', 'assets/audio/MusicGame/thiennga.wav' ); ]]
db:exec(thiennga);
local chim = [[insert into tblMusicGame values(11, 'chim', 'assets/audio/MusicGame/conchim.wav' ); ]]
db:exec(chim);

local function closeConnection()
	if(db and db:isopen() ) then
		db:close();
	end
end
closeConnection();


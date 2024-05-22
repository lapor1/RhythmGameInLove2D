local BackgroundParticles = require "BackgroundParticles"
local MetadataInterpreter = require "MetadataInterpreter"

SongPlayer = require "SongPlayer"


local SongSelectorMenu = {}

local songId = 1
local nSongs = 4
local nPlayers = 1
local sm = 1 -- speed multiple

local file = ""
local data = {}

local function actualizateDataSong()
    file = "music_" .. songId
    MetadataInterpreter.initFile(file)
    data = MetadataInterpreter.readFile()
end

local function startNewGame()
    BackgroundParticles.init(
        data.backgound_color_A,
        data.backgound_color_B,
        data.backgound_density,
        50,                     -- velocidad
        data.backgound_bouncy,
        data.backgound_min_size_particle,
        data.backgound_max_size_particle
    )
    SongPlayer.new(
        file,                   -- song/file name
        nPlayers,               -- players
        data.init_speed * sm,
        data.init_bpm,
        data.keys_per_player,
        false                   -- multiplayer
    )
end

local function left()
    songId = songId - 1
    if songId == 0  then
        songId = nSongs
    end
end

local function right()
    songId = songId + 1
    if songId == (nSongs + 1)  then
        songId = 1
    end
end

function SongSelectorMenu.init()
    --BackgroundParticles.init()
    buttons.songsMenu_stage.play = Button("Play", startNewGame, nil)
    buttons.songsMenu_stage.left= Button("<", left, nil, 40, 50)
    buttons.songsMenu_stage.right= Button(">", right, nil, 40, 50)
    actualizateDataSong()
end

function SongSelectorMenu.update()

end

function SongSelectorMenu.draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("Select your song", 10, 10)
    love.graphics.print("Song = " .. songId, 10, 30)
    love.graphics.print("Speed multiple = " .. sm, 10, 50)
    love.graphics.print("Players = " .. nPlayers, 10, 70)

    buttons.songsMenu_stage.play:draw(800,20,10,20)
    buttons.songsMenu_stage.left:draw(750,20,10,10)
    buttons.songsMenu_stage.right:draw(950,20,10,10)


    love.graphics.print("Name = " .. data.name, 600, 100)
    love.graphics.print("Artist = " .. data.artist, 600, 120)
    love.graphics.print("Compass = " .. data.compass, 600, 140)
    love.graphics.print("Dificulty = " .. data.dificulty, 600, 160)
    love.graphics.print("Min BPM = " .. data.min_bpm, 600, 180)
    love.graphics.print("Max BPM = " .. data.max_bpm, 600, 200)
    love.graphics.print("Keys = " .. data.keys_per_player, 600, 220)
end

function SongSelectorMenu.keypressed(key)
    if (key == "left") and (songId > 1) then 
        songId = songId - 1
        actualizateDataSong()
    end
    if (key == "right") and (songId < 4) then 
        songId = songId + 1
        actualizateDataSong()
    end
    if key == "escape" then 
        gameState["menu"] = true
        gameState["songsMenu"] = false
    end
end

function SongSelectorMenu.mousepressed(button, x, y)
    if button == 1 then
        if gameState["songsMenu"] then
            for i in pairs(buttons.songsMenu_stage) do
                buttons.songsMenu_stage[i]:checkIfClicked(x, y)
            end
        end
    end
end

return SongSelectorMenu
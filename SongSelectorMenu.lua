BackgroundParticles = require "BackgroundParticles"
SongPlayer = require "SongPlayer"

local SongSelectorMenu = {}

local songId = 4
local nSongs = 4

local function startNewGame()
    gameState["songsMenu"] = false
    gameState["running"] = true
    BackgroundParticles.new({r=255, g=0, b=0}, {r=255, g=0, b=255})

    song = SongPlayer.init() 

    if songId == 1 then 
        SongInterpreter.Init("music_1", 3)
        SongPlayer.new(song, 300, 130, "music_1", 3)
    end
    if songId == 2 then 
        SongInterpreter.Init("music_2", 4)
        SongPlayer.new(song, 400, 200, "music_2", 4)
    end
    if songId == 3 then 
        SongInterpreter.Init("music_3", 4)
        SongPlayer.new(song, 400, 140, "music_3", 4)
    end
    if songId == 4 then
        SongInterpreter.Init("music_4", 3)
        love.audio.setVolume(0.2)
        SongPlayer.new(song, 400, 130, "music_4", 3)
    end

    --songPlayer = SongPlayer.init()
    --songInterpreter = SongInterpreter.init()
    -- SongPlayer.new(songInterpreter, 400, 140, "music_4")
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
    buttons.songsMenu_stage.play = Button("Play", startNewGame, nil)
    buttons.songsMenu_stage.left= Button("<", left, nil, 40, 50)
    buttons.songsMenu_stage.right= Button(">", right, nil, 40, 50)
end

function SongSelectorMenu.update()

end

function SongSelectorMenu.draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("Select your song", 10, 10)
    love.graphics.print("Song = " .. songId, 10, 30)

    buttons.songsMenu_stage.play:draw(800,20,10,20)
    buttons.songsMenu_stage.left:draw(750,20,10,10)
    buttons.songsMenu_stage.right:draw(950,20,10,10)
    
end

function SongSelectorMenu.keypressed(key)
    if (key == "left") and (songId >= 1) then 
        songId = songId - 1
    end
    if (key == "right") and (songId <= 4) then 
        songId = songId + 1
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
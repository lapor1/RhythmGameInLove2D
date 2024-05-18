BackgroundParticles = require "BackgroundParticles"
SongPlayer = require "SongPlayer"

local SongSelectorMenu = {}

local songId = 4
local nSongs = 4

local function startNewGame()
    gameState["songsMenu"] = false
    gameState["running"] = true
    BackgroundParticles.new({r=255, g=0, b=0}, {r=255, g=0, b=255})

    if songId == 1 then 
        SongInterpreter.init("music_1", 3)
        song = SongPlayer.new(300, 130, 3, playersData[1], "music_1")
    end
    if songId == 2 then 
        SongInterpreter.init("music_2", 4)
        song = SongPlayer.new(400, 200, 4, playersData[1], "music_2")
    end
    if songId == 3 then 
        SongInterpreter.init("music_3", 4)
        song = SongPlayer.new(400, 140, 4, playersData[1], "music_3")
    end
    if songId == 4 then
        SongInterpreter.init("music_4", 3)
        love.audio.setVolume(0.5)
        song = SongPlayer.new(400, 130, 3, playersData[1], "music_4")
    end

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
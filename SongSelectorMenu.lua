SongPlayer = require "SongPlayer"

local SongSelectorMenu = {}

local songId = 1
local nSongs = 4

local function startNewGame()
    gameState["songsMenu"] = false
    
    
    if songId == 1 then
        SongPlayer.new("music_1", 2, 300, 130, 3)
    end
        --songs[1] = PlayerPlayer.new(300, 130, 3, playersData[1], "music_1", true)
        --songs[2] = PlayerPlayer.new(300, 130, 3, playersData[2], "music_1", false)
    --end
    --[[
    if songId == 2 then 
        SongInterpreter.init("music_2", 4)
        songs[1] = PlayerPlayer.new(400, 200, 4, playersData[1], "music_2", true)
    end
    if songId == 3 then 
        SongInterpreter.init("music_3", 4)
        songs[1] = PlayerPlayer.new(400, 140, 4, playersData[1], "music_3", true)
    end
    if songId == 4 then
        SongInterpreter.init("music_4", 3)
        love.audio.setVolume(0.5)
        songs[1] = PlayerPlayer.new(400, 130, 3, playersData[1], "music_4", true)
    end
    ]]
    
    gameState["running"] = true
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
    if (key == "left") and (songId > 1) then 
        songId = songId - 1
    end
    if (key == "right") and (songId < 4) then 
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
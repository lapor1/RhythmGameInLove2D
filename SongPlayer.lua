PlayerPlayer = require "PlayerPlayer"
SongInterpreter = require "SongInterpreter"
local BackgroundParticles = require "BackgroundParticles"

local SongPlayer = {}

local songs = {}
local files = {}
local nPlayers = 0
local songPlaying = false
local initCounter = 0
local offset = 0
local endedSongs = {}

function SongPlayer.new(musicFile, nP, speed, bpm, nKeys)
    BackgroundParticles.new({r=255, g=0, b=0}, {r=255, g=0, b=255})

    
    songPlaying = false
    initCounter = 0
    offset = notesHigh  / speed
    nPlayers = nP
    endedSongs = {}
    endTimer = 0
    
    for idPlayer = 1, nPlayers do
        files[idPlayer] = SongInterpreter.init(musicFile, 3, idPlayer)
        songs[idPlayer] = PlayerPlayer.new(speed, bpm, nKeys, playersData[idPlayer], idPlayer)
        PlayerPlayer.init(songs[idPlayer], files[idPlayer])
        endedSongs[idPlayer] = false
    end

    music = love.audio.newSource("songs/" .. musicFile .. ".wav", "static")
end

function SongPlayer.update(dt)
    BackgroundParticles.update(dt)

    if (not songPlaying) then     
        if (initCounter >= offset) then
            songPlaying = true 
            love.audio.play(music)
        else
            initCounter = initCounter + dt
        end
    end

    
    for idPlayer = 1, nPlayers do 
        PlayerPlayer.update(songs[idPlayer], files[idPlayer], dt)


        endedSongs[idPlayer] = songs[idPlayer].endSong
    end


    if endedSongs[1] and endedSongs[2] then
        endTimer = endTimer + dt
        if endTimer >= offset then
            gameState["running"] = false
            gameState["songsMenu"] = true
        end
    end

end

function SongPlayer.draw()
    BackgroundParticles.draw()
    
    for idPlayer = 1, nPlayers do
        PlayerPlayer.draw(songs[idPlayer], dt)
    end
end

function SongPlayer.keypressed(key)
    if key == "escape" then
        gameState["running"] = false
        gameState["songsMenu"] = true
        love.audio.stop(music)
    else
        for idPlayer = 1, nPlayers do
            PlayerPlayer.checkKey(songs[idPlayer], key)
        end
    end
end

return SongPlayer
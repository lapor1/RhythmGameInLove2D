local PlayerPlayer = require "PlayerPlayer"
local SongInterpreter = require "SongInterpreter"
local BackgroundParticles = require "BackgroundParticles"

local SongPlayer = {}

local songs = {}
local nPlayers = 0
local songPlaying = false
local initCounter = 0
local offset = 0

function SongPlayer.init()
end

function SongPlayer.new(musicFile, nP, speed, bpm)
    BackgroundParticles.new({r=255, g=0, b=0}, {r=255, g=0, b=255})

    SongInterpreter.init(musicFile, 3)
    
    songPlaying = false
    initCounter = 0
    offset = notesHigh  / speed
    nPlayers = nP

    for i = 1, nPlayers do
        --songs[i] = {}
        songs[i] = PlayerPlayer.new(speed, bpm, 3, playersData[i], i)
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

    for i = 1, nPlayers do
        PlayerPlayer.update(songs[i], dt)
    end
end

function SongPlayer.draw()
    BackgroundParticles.draw()
    
    for i = 1, nPlayers do
        PlayerPlayer.draw(songs[i], dt)
    end
end

function SongPlayer.keypressed(key)
    if key == "escape" then
        gameState["running"] = false
        gameState["songsMenu"] = true
        love.audio.stop(music)
    else
        for i = 1, nPlayers do
            PlayerPlayer.checkKey(songs[i], key)
        end
    end
end

return SongPlayer
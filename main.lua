local Button = require "Button"
local BackgroundParticles = require "BackgroundParticles"
Key = require "Key"
local SongPlayer = require "SongPlayer"
local Menu = require "Menu"
local SongSelectorMenu = require "SongSelectorMenu"
local Player = require "Player"

function love.load()
    gameState = {
        menu = true,
        songsMenu = false,
        config = false,
        running = false,
        pause = false,
    }

    buttons = {
        menu_stage = {},
        songsMenu_stage = {}
    }


    playersData = {}
    playersData[1] = Player.init()

    BackgroundParticles.init()
    keys = {}
    notesHigh = love.graphics.getHeight() - 120
       
    SongSelectorMenu.init()
    Menu.init()
    
    song = {}
end

function love.mousepressed(x, y, button, istouch, presses)
    if gameState["menu"] then
        Menu.mousepressed(button, x, y)
    end
    if gameState["songsMenu"] then
        SongSelectorMenu.mousepressed(button, x, y)
    end  
    if gameState["config"] then
        --...
    end
    if gameState["running"] then
        --...
    end
    if gameState["pause"] then
        --...
    end
end

function love.keypressed(key)
    if gameState["menu"] then
        Menu.keypressed(key)
    end
    if gameState["songsMenu"] then
        SongSelectorMenu.keypressed(key)
    end
    if gameState["config"] then
        --...
    end
    if gameState["running"] then
        SongPlayer.keypressed(song, key)
    end
    if gameState["pause"] then
        --...
    end
end


function love.update(dt)
    if gameState["menu"] then
        Menu.update()
    end
    if gameState["songsMenu"] then
        SongSelectorMenu.update()
    end
    if gameState["config"] then
        --...
    end
    if gameState["running"] then
        BackgroundParticles.update(dt)
        SongPlayer.update(song, dt)
    end
    if gameState["pause"] then
        --...
    end
end

function love.draw()
    if gameState["menu"] then
        Menu.draw()
    end
    if gameState["songsMenu"] then
        SongSelectorMenu.draw()
    end
    if gameState["running"] then
        BackgroundParticles.draw()
        SongPlayer.draw(song, dt)
    end
    if gameState["config"] then
        --...
    end
    if gameState["pause"] then
        --...
    end
end
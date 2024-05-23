local Button = require "Button"
--Key = require "Key"
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
    playersData[1] = Player.init(800, {"a","s","d","f"})
    playersData[2] = Player.init(200, {"g","j","k","l"})
    
    --keys = {}
    notesHigh = love.graphics.getHeight() - 120
       
    SongSelectorMenu.init()
    Menu.init()
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
    local change = false
    if gameState["menu"] and not change then
        Menu.keypressed(key)
        change = true
    end
    if gameState["songsMenu"] and not change then
        SongSelectorMenu.keypressed(key)
        change = true
    end
    if gameState["config"] and not change then
        --...
        change = true
    end
    if gameState["running"] and not change then
        SongPlayer.keypressed(key)
        change = true
    end
    if gameState["pause"] and not change then
        --...
        change = true
    end
end


function love.update(dt)
    if gameState["menu"] then
        Menu.update()
    end
    if gameState["songsMenu"] then
        SongSelectorMenu.update(dt)
    end
    if gameState["config"] then
        --...
    end
    if gameState["running"] then
        SongPlayer.update(dt)
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
        SongPlayer.draw()
    end
    if gameState["config"] then
        --...
    end
    if gameState["pause"] then
        --...
    end
end
SongSelectorMenu = require "SongSelectorMenu"
Menu = {}

local function startSongsMenu()
    gameState["menu"] = false
    gameState["running"] = false
    gameState["songsMenu"] = true
    SongSelectorMenu.init()
end



function Menu.init()
    buttons.menu_stage.play = Button("Play", startSongsMenu, nil)
    buttons.menu_stage.config = Button("Config", nil, nil)
    buttons.menu_stage.exit = Button("Exit", love.event.quit, nil)
end

function Menu.update()

end

function Menu.draw()
    buttons.menu_stage.play:draw(10,20,10,20)
    buttons.menu_stage.config:draw(10,120,10,20)
    buttons.menu_stage.exit:draw(10,220,10,20)
end

return Menu
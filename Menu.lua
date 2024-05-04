SongSelectorMenu = require "SongSelectorMenu"
Menu = {}

local function startSongsMenu(self)
    self.selector = 0
    gameState["menu"] = false
    gameState["running"] = false
    gameState["songsMenu"] = true
    SongSelectorMenu.init()
end

local self = {
    selector = 0,
    w = love.graphics.getWidth(),
    h = love.graphics.getHeight(),
    buttonsWidth = 400,
    buttonsHeight = 50,
}

function Menu.init()
    buttons.menu_stage.play = Button("P l a y   N e w   S o n g", startSongsMenu, self, self.buttonsWidth, self.buttonsHeight)
    buttons.menu_stage.config = Button("C o n f i g u r a t i o n", nil, nil, self.buttonsWidth, self.buttonsHeight)
    buttons.menu_stage.exit = Button("E x i t   T o   D e s k t o p", love.event.quit, nil, self.buttonsWidth, self.buttonsHeight)
end

function Menu.keypressed(key)
    if key == "down" and (self.selector < 2) then
        self.selector = self.selector + 1
    end
    if key == "up" and (self.selector > 0) then
        self.selector = self.selector - 1
    end
    if key == "space" or key == "kpenter" or key == "return" then
        if self.selector == 0 then
            startSongsMenu(self)
        end
        if self.selector == 2 then
            love.event.quit()
        end
    end
    if key == "escape" then
        love.event.quit()
    end
end

function Menu.checkIfClicked(x, y)
    for i in pairs(buttons.menu_stage) do
        buttons.menu_stage[i]:checkIfClicked(x, y)
    end
end

function Menu.update()
    local x,y =  love.mouse.getPosition()
    for i in pairs(buttons.menu_stage) do
        if ((x > buttons.menu_stage[i].button_x) and (x < self.buttonsWidth) and (y > buttons.menu_stage[i].button_y) and (x < self.buttonsHeight)) then
            self.selector = i
        end
    end
end

function Menu.draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("nombre del juego", self.w/2, self.h/3)
    buttons.menu_stage.play:draw(self.w/2 - self.buttonsWidth/2, self.h*3/6, self.buttonsWidth/2, self.buttonsHeight/2)
    buttons.menu_stage.config:draw(self.w/2 - self.buttonsWidth/2, self.h*4/6, self.buttonsWidth/2, self.buttonsHeight/2)
    buttons.menu_stage.exit:draw(self.w/2 - self.buttonsWidth/2, self.h*5/6, self.buttonsWidth/2, self.buttonsHeight/2)
    love.graphics.setColor(1,1,1,0.2)
    love.graphics.rectangle("fill", self.w/2 - self.buttonsWidth/2, self.h*(self.selector + 3)/6, self.buttonsWidth, self.buttonsHeight)
end

return Menu
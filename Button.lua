function Button(text, func, funcParam, width, height)
    return {
        width = width or 100,
        height = height or 50,
        func = func or function() print("error") end,
        funcParam = funcParam,
        text = text or "empty",
        button_x = 0,
        button_y = 0,
        text_x = 0,
        text_y = 0,

        checkIfClicked = function(self, mouse_x, mouse_y)
            if mouse_x >= self.button_x and mouse_x <= self.button_x + self.width and
            mouse_y >= self.button_y and mouse_y <= self.button_y + self.height then
                if self.funcParam then
                    self.func(self.funcParam)
                else
                    self.func()
                end
            end
        end,

        draw = function(self, button_x, button_y, text_x, text_y)
            self.button_x = button_x or self.button_x
            self.button_y = button_y or self.button_y
        
            if text_x then
                self.text_x = text_x + self.button_x
            else
                self.text_x = self.button_x
            end

            if text_y then
                self.text_y = text_y + self.button_y
            else
                self.text_y = self.button_y
            end

            love.graphics.setColor(1,1,1)
            love.graphics.rectangle("line", self.button_x, self.button_y, self.width, self.height)
            love.graphics.print(self.text, self.text_x, self.text_y)     
        end
    }
end

return Button
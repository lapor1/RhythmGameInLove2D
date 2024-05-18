local KeyParticles = require "KeyParticles"

local Key = {}

local radius = 25
local radiusWhenPush = 15
local perticleSpeed = 0.05
local triggerSustain = 0.2 -- in seconds

local rectangleWidth = 30

lineNoteWidth = 40

function Key.init(keys, key_notes, nKeys)
    for i = 1, nKeys do
        local j =  i + #key_notes - nKeys
        keys[i] = Key.new(key_notes[j][2], key_notes[j][3], key_notes[j][4])
    end
    --return keys
end

function Key.new(x, key, color)
    local self = {
        x = x + playersData[1].xCoord,
        y = notesHigh,
        key = key,
        isPush = false,
        keyParticles = {},
        count = 0,
        size = 0,
        trigger = false,
        triggerCount = 0,
        color = {
            r = color.r,
            g = color.g,
            b = color.b
        },
        --xCoord = playersData[1].xCoord,
        --sound = love.audio.newSource("sounds/" .. sound .. ".wav", "static")
    }
    return self
end

function Key.update(self, dt, i, key)
    self.isPush = love.keyboard.isDown(key)
    Key.makeParticles(self, dt)
    for j=1, self.size do
        self.keyParticles[j]:update(dt)
        if (self.keyParticles[j].velocity <= 0) then 
            Key.eliminateParticle(self, j)   
        end
    end
end

function Key.makeParticles(self, dt)
    if (self.isPush == true) and (self.trigger == false) then
        self.trigger = true
    end
    if (self.trigger) then 
        self.count = self.count + dt
        if self.count > perticleSpeed then
            self.size = self.size + 1
            self.keyParticles[self.size] = KeyParticles.New(self.x, self.y)
            self.count = 0
        end
        self.triggerCount = self.triggerCount + dt
        if (self.triggerCount >= triggerSustain) then 
            self.triggerCount = 0
            self.trigger = false
        end
    end
end

function Key.eliminateParticle(self, j)
    self.size = self.size - 1
    for k=j, self.size do
        self.keyParticles[k] = self.keyParticles[k+1]
    end
end

function Key.draw(self)
    love.graphics.setColor(0.3,0.3,0.3,1) 
    love.graphics.line(self.x - lineNoteWidth, notesHigh, self.x + lineNoteWidth, notesHigh)
    love.graphics.line(self.x - lineNoteWidth, love.graphics.getHeight(), self.x - lineNoteWidth, 0)
    love.graphics.line(self.x + lineNoteWidth, love.graphics.getHeight(), self.x + lineNoteWidth, 0)
    for i=1, self.size do
        self.keyParticles[i]:draw()
    end
    if (self.isPush) then 
        love.graphics.setColor(1,1,1,0.1) 
        love.graphics.rectangle("fill", self.x - rectangleWidth, 0, rectangleWidth * 2, love.graphics.getHeight())
        love.graphics.setColor(1,1,1,1)
        love.graphics.circle('line', self.x, self.y, radius * 0.8)
        love.graphics.setColor(self.color.r, self.color.g, self.color.b,1)
        love.graphics.circle('fill', self.x, self.y, radius * 0.5)
        love.graphics.setColor(0,0,0)
        love.graphics.print(self.key, self.x - 4, self.y - 7)
    else
        love.graphics.setColor(1,1,1,1)
        love.graphics.circle('line', self.x, self.y, radius)
        love.graphics.circle('fill', self.x, self.y, radius * 0.8)
        love.graphics.setColor(self.color.r, self.color.g, self.color.b,0.7)
        love.graphics.circle('fill', self.x, self.y, radius * 0.5)
        love.graphics.setColor(0,0,0)
        love.graphics.print(self.key, self.x - 4, self.y - 7)
    end
end

function Key.playSound(self)
    --love.audio.stop(self.sound)
    --love.audio.play(self.sound)
end

return Key
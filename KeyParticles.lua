KeyParticles = {}

local radius = 2
local factorDegradation = 0.99
local bouncyAmp = 1
local bouncyFrec = 10
local width = 15
local initVelocity = 1000
local aceleration = 5000

function KeyParticles.New(x, y)
    local self = setmetatable({}, KeyParticles)

    self = {
        x = x + love.math.random(-width, width),
        y = y,
        velocity = initVelocity,
        direction = math.pi * love.math.random(0,50) * 0.01 + math.pi * 0.25,
        color = {
            r = 1,
            g = love.math.random(0, 100) * 0.01,
            b = 0,
            a = 1
        }
    }

    self.update = function(self, dt)
        self.x = self.x + math.cos(self.direction) * self.velocity * dt
        self.y = self.y - math.sin(self.direction) * self.velocity * dt
        self.velocity = self.velocity - aceleration * dt
        self:changeColor()
    end
    
    self.changeColor = function(self)
        --self.color.r = self.color.r * factorDegradation
        --self.color.g = self.color.g * factorDegradation
        self.color.a = self.color.a * factorDegradation
    end

    self.draw = function(self)
        --love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
        love.graphics.setColor(1,1,1,self.color.a)
        love.graphics.circle("fill", self.x, self.y, radius)
    end

    return self
end

return KeyParticles
local BackgroundParticles = {}

local self = {}

function BackgroundParticles.init()
    self = {    
        velocity = 50,
        density = 100,
        min_size = 10,
        max_size = 100,
        bouncy = 10,
        particle = {},
        keysThatChangeVelocity = {
            playersData[1].keys[1][1],
            playersData[1].keys[2][1],
        },
    }
end

function BackgroundParticles.new(color_A, color_B)
    for i = 1, self.density do
        self.particle[i] = {}
        self.particle[i].x = love.math.random(0, love.graphics.getWidth())
        self.particle[i].y = love.math.random(0, love.graphics.getHeight())

        self.particle[i].size =  math.pow(love.math.random(self.min_size, self.max_size),2) / self.max_size

        self.particle[i].color = {}
        self.particle[i].color.r = love.math.random(color_A.r, color_B.r+1)/256
        self.particle[i].color.g = love.math.random(color_A.g, color_B.g+1)/256
        self.particle[i].color.b = love.math.random(color_A.b, color_B.b+1)/256
        self.particle[i].color.a = love.math.random(50)/256
    end
end

function BackgroundParticles.update(dt)
    local velocity
    if love.keyboard.isDown(self.keysThatChangeVelocity[1]) or love.keyboard.isDown(self.keysThatChangeVelocity[2]) then
        velocity = 25
    else
        velocity = 5
    end
    for i = 1, self.density do
        self.particle[i].x = self.particle[i].x + math.cos(self.particle[i].y/self.particle[i].size)*self.bouncy*dt
        self.particle[i].y = self.particle[i].y - (self.velocity * velocity / math.sqrt(self.particle[i].size))*dt

        if self.particle[i].y < (self.particle[i].size)*(-2) then
            self.particle[i].x = love.math.random(0, love.graphics.getWidth())
            self.particle[i].size =  math.pow(love.math.random(self.min_size, self.max_size),2) / self.max_size
            self.particle[i].y = love.graphics.getHeight() + self.particle[i].size * 2
        end
    end
end

function BackgroundParticles.draw()
    for i = 1, self.density do
        love.graphics.setColor(self.particle[i].color.r, self.particle[i].color.g, self.particle[i].color.b, self.particle[i].color.a)
        love.graphics.circle('fill', self.particle[i].x, self.particle[i].y, self.particle[i].size)
    end
end

return BackgroundParticles
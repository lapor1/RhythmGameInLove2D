local BackgroundParticles = {}

function BackgroundParticles.init()
    local self = {    
        velocity = 50,
        density = 100,
        min_size = 10,
        max_size = 100,
        bouncy = 10,
        particle = {}
    }
    return self
end

function BackgroundParticles.new(bp, color_A, color_B)
    for i = 1, bp.density do
        bp.particle[i] = {}
        bp.particle[i].x = love.math.random(0, love.graphics.getWidth())
        bp.particle[i].y = love.math.random(0, love.graphics.getHeight())

        bp.particle[i].size =  math.pow(love.math.random(bp.min_size, bp.max_size),2) / bp.max_size

        bp.particle[i].color = {}
        bp.particle[i].color.r = love.math.random(color_A.r, color_B.r+1)/256
        bp.particle[i].color.g = love.math.random(color_A.g, color_B.g+1)/256
        bp.particle[i].color.b = love.math.random(color_A.b, color_B.b+1)/256
        bp.particle[i].color.a = love.math.random(50)/256
    end
end

function BackgroundParticles.update(bp, dt, velocity)
    local velocity
    if love.keyboard.isDown(key_notes[1][1]) or love.keyboard.isDown(key_notes[2][1]) then
        velocity = 25
    else
        velocity = 5
    end
    for i = 1, bp.density do
        bp.particle[i].x = bp.particle[i].x + math.cos(bp.particle[i].y/bp.particle[i].size)*bp.bouncy*dt
        bp.particle[i].y = bp.particle[i].y - (bp.velocity * velocity / math.sqrt(bp.particle[i].size))*dt

        if bp.particle[i].y < (bp.particle[i].size)*(-2) then
            bp.particle[i].x = love.math.random(0, love.graphics.getWidth())
            bp.particle[i].size =  math.pow(love.math.random(bp.min_size, bp.max_size),2) / bp.max_size
            bp.particle[i].y = love.graphics.getHeight() + bp.particle[i].size * 2
        end
    end
end

function BackgroundParticles.draw(self)
    for i = 1, self.density do
        love.graphics.setColor(self.particle[i].color.r, self.particle[i].color.g, self.particle[i].color.b, self.particle[i].color.a)
        love.graphics.circle('fill', self.particle[i].x, self.particle[i].y, self.particle[i].size)
    end
end

return BackgroundParticles
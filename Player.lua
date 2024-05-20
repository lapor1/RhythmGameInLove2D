local Player = {}

function Player.init(x, keysPlayer)
    local self = {
        name = "asdf",
        xCoord = x,
        xData = x - 200,
        keys = {
            {keysPlayer[1], 0, keysPlayer[1], {r=1, g=0, b=0}},
            {keysPlayer[2], 100, keysPlayer[2], {r=1, g=0.5, b=1}},
            {keysPlayer[3], 250, keysPlayer[3], {r=0, g=0.5, b=1}},
            {keysPlayer[4], 350, keysPlayer[4], {r=0, g=1, b=1}} 
        },
        maxScore = 0,
    }
    return self
end


return Player
local Player = {}

function Player.init()
    local self = {
        name = "asdf",
        xCoord = 800,
        keys = {
            {"d", 0, "D", {r=1, g=0, b=0}},
            {"f", 100, "F", {r=1, g=0.5, b=1}},
            {"h", 250, "H", {r=0, g=0.5, b=1}},
            {"j", 350, "J", {r=0, g=1, b=1}} 
        },
        maxScore = 0,
    }
    return self
end

return Player
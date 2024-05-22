local MetadataInterpreter = {}

local file

local data = {
    name = "",
    artist = "",
    compass = "",
    dificulty = "",
    init_speed = 0,
    init_bpm = 0,
    min_bpm = 0,
    max_bpm = 0,
    max_players = 1,
    keys_per_player = 0,
    backgound_color_A = {r=0, b=0, g=0},
    backgound_color_B = {r=0, b=0, g=0},
    backgound_density = 0,
    backgound_bouncy = 0,
    backgound_min_size_particle = 0,
    backgound_max_size_particle = 0,
}

local function readLineString()
    local stringLine = file:read("*line")
    local i = 1
    while ( string.sub(stringLine, i, i) ~= '=') do
        i = i + 1
    end
    i = i + 2
    local j = i
    while ( string.sub(stringLine, i, i) ~= ',') do
        i = i + 1
    end
    return string.sub(stringLine, j+1, i-2)
end

local function readLineInt()
    local stringLine = file:read("*line")
    local i = 1
    while ( string.sub(stringLine, i, i) ~= '=') do
        i = i + 1
    end
    i = i + 1
    local j = i
    while ( string.sub(stringLine, i, i) ~= ',') do
        i = i + 1
    end
    return tonumber(string.sub(stringLine, j+1, i-1))
end

local function readLineColor()
    local color = {r=0,g=0,b=0}
    local stringLine = file:read("*line")
    local i = 1
    while ( string.sub(stringLine, i, i) ~= '{') do
        i = i + 1
    end
    i = i + 1
    local j = i
    while ( string.sub(stringLine, i, i) ~= ',') do
        i = i + 1
    end
    color.r = tonumber(string.sub(stringLine, j, i-1))
    i = i + 1
    j = i
    while ( string.sub(stringLine, i, i) ~= ',') do
        i = i + 1
    end
    color.g = tonumber(string.sub(stringLine, j, i-1))
    i = i + 1
    j = i
    while ( string.sub(stringLine, i, i) ~= '}') do
        i = i + 1
    end
    color.b = tonumber(string.sub(stringLine, j, i-1))

    return color
end

function MetadataInterpreter.initFile(nameFile)
    file = assert(io.open("songs/" .. nameFile .. "/" .. nameFile .. "_metadata.lpr", "r"))
end

function MetadataInterpreter.readFile()
    data.name = readLineString()
    data.artist = readLineString()
    data.compass = readLineString()
    data.dificulty = readLineString()
    data.init_speed = readLineInt()
    data.init_bpm = readLineInt()
    data.min_bpm = readLineInt()
    data.max_bpm = readLineInt()
    data.max_players = readLineInt()
    data.keys_per_player = readLineInt()
    data.backgound_color_A = readLineColor()
    data.backgound_color_B = readLineColor()
    data.backgound_density = readLineInt()
    data.backgound_bouncy = readLineInt()
    data.backgound_min_size_particle = readLineInt()
    data.backgound_max_size_particle = readLineInt()

    return data
end

return MetadataInterpreter
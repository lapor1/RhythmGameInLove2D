local SongInterpreter = {}

function SongInterpreter.init()
    local self = {
        file, bpm, speed,
        endSong = false,

        readedCounter = 1,
        readingNotes = false,
        stringLine = "",
    }
    return self
end

function SongInterpreter.initFile(self)
    self.music = love.audio.newSource("sounds/" .. musicFile .. ".wav", "static")
    self.file = assert(io.open(musicFile .. ".lpr", "r"))
    self.speed = speed
    self.bpm = bpm 
    self.offset = notesHigh / self.speed
    self.rangeTime = 60 * 4 / self.bpm
end

function SongInterpreter.interpretLine(self)
    --Read line
    if (not self.readingNotes) then self.stringLine = self.file:read("*line") end
    --Check if song ended
    if (self.stringLine == "end") then
        -- termina la cancion
        self.endSong = true
        SongPlayer.createCompassLine(self)
        return true
    --Read atributes
    elseif (string.sub(self.stringLine, 1,1) == "[") then
        local i = 2
        local j
        while (string.sub(self.stringLine, i, i) ~= "]") do
            if (string.sub(self.stringLine, i, i + 1) == "c=") then
                i = i + 2; j = i
                while (string.sub(self.stringLine, j, j) ~= "/") do j = j + 1 end
                self.compass.dividen = tonumber(string.sub(self.stringLine, i, j - 1)); i = j + 1; j = i
                while ((string.sub(self.stringLine, j, j) ~= ",") and (string.sub(self.stringLine, j, j) ~= "]")) do j = j + 1 end
                self.compass.divisor = tonumber(string.sub(self.stringLine, i, j - 1)); i = j
            elseif (string.sub(self.stringLine, i, i + 1) == "b=") then
                i = i + 2; j = i
                while ((string.sub(self.stringLine, j, j) ~= ",") and (string.sub(self.stringLine, j, j) ~= "]")) do j = j + 1 end
                self.bpm = tonumber(string.sub(self.stringLine, i, j - 1))
                self.rangeTime = 60 * 4 / self.bpm; i = j
            elseif (string.sub(self.stringLine, i, i + 1) == "s=") then
                i = i + 2; j = i
                while ((string.sub(self.stringLine, j, j) ~= ",") and (string.sub(self.stringLine, j, j) ~= "]")) do j = j + 1 end
                self.speed = tonumber(string.sub(self.stringLine, i, j - 1)); i = j
            elseif (string.sub(self.stringLine, i, i + 1) == "m=") then
                i = i + 2; j = i
                while ((string.sub(self.stringLine, j, j) ~= ",") and (string.sub(self.stringLine, j, j) ~= "]")) do j = j + 1 end
                self.compass.msg = string.sub(self.stringLine, i, j - 1); i = j
            else
                i = i + 1
            end
        end
        SongPlayer.createCompassLine(self)
        return false
    -- Coments
    elseif (string.sub(self.stringLine, 1,1) == "") or (string.sub(self.stringLine, 1,1) == " ") or (string.sub(self.stringLine, 1,1) == "-") then
        return false
    --Read Notes
    else
        if (not self.readingNotes) then
            self.readingNotes = true
            SongPlayer.createCompassLine(self)
        end 
        --lee notas
        local noteCoord = (self.readedCounter - 1) * (#key_notes + 1)
        for i = 1, #key_notes do
            if (string.sub(self.stringLine, noteCoord + i, noteCoord + i) == 'X') then
                SongPlayer.createNewNote(self, i)
            end
        end
        if (self.readedCounter < self.compass.dividen) then
            self.readedCounter = self.readedCounter + 1
        else 
            self.readedCounter = 1
            self.readingNotes = false
        end
        return true
    end
    return false
end

return SongInterpreter
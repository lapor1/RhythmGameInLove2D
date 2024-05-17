local SongInterpreter = {}

local self = {}

function SongInterpreter.Init(musicFile, nKeys)
    self = {
        file  = assert(io.open("songs/" .. musicFile .. ".lpr", "r")),
                
        readedCounter = 1,
        readingNotes = false,
        stringLine = "",
        nKeys = nKeys,
        fisrtCompass = false,

    }
    return self
end

local function readLineFormFile()
    
end


function SongInterpreter.interpretLine(songPlayer, compass, endSong)

    --Read line
    --readLineFromFile()
    if (not self.readingNotes) then 
        self.stringLine = self.file:read("*line") 
    end

    --Check if song ended
    if (self.stringLine == "end") then
        -- termina la cancion
        endSong = true

        SongPlayer.createCompassLine(songPlayer, false)
        return true

    --Read atributes
    elseif (string.sub(self.stringLine, 1,1) == "[") then
        local i = 2
        local j
        local hasMsg = false
        local changeCompass = false
        while (string.sub(self.stringLine, i, i) ~= "]") do
            if (string.sub(self.stringLine, i, i + 1) == "c=") then
                i = i + 2; j = i
                while (string.sub(self.stringLine, j, j) ~= "/") do j = j + 1 end
                compass.dividen = tonumber(string.sub(self.stringLine, i, j - 1)); i = j + 1; j = i
                while ((string.sub(self.stringLine, j, j) ~= ",") and (string.sub(self.stringLine, j, j) ~= "]")) do j = j + 1 end
                compass.divisor = tonumber(string.sub(self.stringLine, i, j - 1)); i = j
                changeCompass = true
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
                compass.msg = string.sub(self.stringLine, i, j - 1); i = j
                hasMsg = true
            else
                i = i + 1
            end
        end

        if changeCompass and not hasMsg then 
            compass.msg = compass.dividen .. "/" .. compass.divisor
        end
        self.fisrtCompass = true
        return false

    -- Coments
    elseif (string.sub(self.stringLine, 1,1) == "") or (string.sub(self.stringLine, 1,1) == " ") or (string.sub(self.stringLine, 1,1) == "-") then
        return false

    --Read Notes
    else
        if (not self.readingNotes) then
            self.readingNotes = true
            
            if self.fisrtCompass then
                SongPlayer.createCompassLine(songPlayer, true, true)
                self.fisrtCompass = false
            else
                SongPlayer.createCompassLine(songPlayer, false, true)
            end
            
            --SongPlayer.createCompassLine(songPlayer, true)
        end 

        --lee notas
        local noteCoord = (self.readedCounter - 1) * (self.nKeys + 1)
        for i = 1, self.nKeys do
            if (string.sub(self.stringLine, noteCoord + i, noteCoord + i) == 'X') then
                SongPlayer.createNewNote(songPlayer, i)

            end
        end
        if self.readedCounter > 1 then 
            SongPlayer.createCompassLine(songPlayer, false, false)
        end
        if (self.readedCounter < compass.dividen) then
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
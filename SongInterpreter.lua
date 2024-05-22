local SongInterpreter = {}

function SongInterpreter.init(musicFile, nKeys, idPlayer)
    local self = {
        --file  = assert(io.open("songs/" .. musicFile .. "_p" .. idPlayer .. ".lpr", "r")),
        file  = assert(io.open("songs/" .. musicFile .. "_p1.lpr", "r")),
                
        readedCounter = 1,
        readingNotes = false,
        stringLine = "",
        nKeys = nKeys,
        fisrtCompass = false,

    }
    return self
end

function SongInterpreter.interpretLine(self, song)
    local getNoteOrEnd = false
    while(not getNoteOrEnd) do
        --Read line
        if (not self.readingNotes) then 
            self.stringLine = self.file:read("*line") 
        end
        --Check if song ended
        if (self.stringLine == "end") then
            song.endSong = true
            PlayerPlayer.createCompassLine(song, false, true)
            getNoteOrEnd = true
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
                    song.compass.dividen = tonumber(string.sub(self.stringLine, i, j - 1)); i = j + 1; j = i
                    while ((string.sub(self.stringLine, j, j) ~= ",") and (string.sub(self.stringLine, j, j) ~= "]")) do j = j + 1 end
                    song.compass.divisor = tonumber(string.sub(self.stringLine, i, j - 1)); i = j
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
                    song.compass.msg = string.sub(self.stringLine, i, j - 1); i = j
                    hasMsg = true
                else
                    i = i + 1
                end
            end

            if changeCompass and not hasMsg then 
                song.compass.msg = song.compass.dividen .. "/" .. song.compass.divisor
            end
            self.fisrtCompass = true

        -- Coments
        elseif (string.sub(self.stringLine, 1,1) == "") or (string.sub(self.stringLine, 1,1) == " ") or (string.sub(self.stringLine, 1,1) == "-") then

        --Read Notes
        else
            if (not self.readingNotes) then
                self.readingNotes = true
                if self.fisrtCompass then
                    PlayerPlayer.createCompassLine(song, true, true)
                    self.fisrtCompass = false
                else
                    PlayerPlayer.createCompassLine(song, false, true)
                end
            end 
            --lee notas
            local noteCoord = (self.readedCounter - 1) * (self.nKeys + 1)
            for i = 1, self.nKeys do
                if (string.sub(self.stringLine, noteCoord + i, noteCoord + i) == 'X') then
                    PlayerPlayer.createNewNote(song, i)
                end
            end
            if self.readedCounter > 1 then 
                PlayerPlayer.createCompassLine(song, false, false)
            end
            if (self.readedCounter < song.compass.dividen) then
                self.readedCounter = self.readedCounter + 1
            else 
                self.readedCounter = 1
                self.readingNotes = false
            end
            getNoteOrEnd = true
        end
    end
end

return SongInterpreter
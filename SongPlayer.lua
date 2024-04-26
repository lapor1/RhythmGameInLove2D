--SongInterpreter = require "SongInterpreter"
local SongPlayer = {}


local errorTolerance = 0.5
local perfect_percent = 0.3
local good_percent = 0.6

local perfect_ponits = 0
local good_points = -2.5
local bad_points = -10
local miss_points = -50

local noteRadius = 15

function SongPlayer.init()
    local self = {
        file,
        endSong = false,
        numbersOfKeys,
        speed, bpm, rangeTime, offset,
        timerCounter = 0,
        notesInScreenVector = {},
        notesInScreenSize = 0,
        msg = "",
        compassLine = {},
        compassLineSize = 0,
        compass = {
            dividen = 4,
            divisor = 4,
            msg = ""
        },
        music,
        initCounter = 0,
        songPlaying = false,

        countPlayedNotes = 0,
        points = 1000,

        readedCounter = 1,
        readingNotes = false,
        stringLine = "",
        --interpreter = SongInterpreter.init()
        nKeys = 0
    }
    
    return self
end

function SongPlayer.new(self, speed, bpm, musicFile, nKeys)
    self.music = love.audio.newSource("sounds/" .. musicFile .. ".wav", "static")
    self.file = assert(io.open(musicFile .. ".lpr", "r"))
    self.speed = speed
    self.bpm = bpm 
    self.rangeTime = 60 * 4 / self.bpm
    self.offset = notesHigh / self.speed + (self.rangeTime / self.compass.divisor)
    --self.numbersOfKeys = nKeys
    self.nKeys = nKeys
    Key.init(keys, key_notes, nKeys) 

    --getNoteOrEnd = SongPlayer.interpretLine(self)
end

function SongPlayer.interpretLine(self)
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
        local noteCoord = (self.readedCounter - 1) * (self.nKeys + 1)
        for i = 1, self.nKeys do
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

function SongPlayer.createNewNote(self, i)
    self.notesInScreenSize = self.notesInScreenSize + 1
    self.notesInScreenVector[self.notesInScreenSize] = {}
    self.notesInScreenVector[self.notesInScreenSize].y = 0
    self.notesInScreenVector[self.notesInScreenSize].x = keys[i].x
    self.notesInScreenVector[self.notesInScreenSize].key = i
end

function SongPlayer.createCompassLine(self)
    self.compassLineSize = self.compassLineSize + 1
    self.compassLine[self.compassLineSize] = {}
    self.compassLine[self.compassLineSize].y = 0
    self.compassLine[self.compassLineSize].text = self.compass.msg
end

function SongPlayer.eliminateCompassLine(self, i)
    self.compassLineSize = self.compassLineSize - 1                
    for j=i, self.compassLineSize do
        self.compassLine[j].y = self.compassLine[j+1].y
        self.compassLine[j].text = self.compassLine[j+1].text
    end
end

function SongPlayer.checkNote(self, key)
    -- Chequea la nota mas cerca al jugador
    local min_note_id = 0
    local min_note_coord = love.graphics.getHeight()
    local find_min = false
    for i=1, self.notesInScreenSize do
        if (self.notesInScreenVector[i].key == key) then
            if (math.abs(self.notesInScreenVector[i].y -  notesHigh) < min_note_coord) then 
                min_note_coord = math.abs(self.notesInScreenVector[i].y -  notesHigh)
                min_note_id = i
                find_min = true
            end
        end
    end
    -- Compara la diferencia con el jugador
    if (find_min) then
        local errorHit = math.abs(self.notesInScreenVector[min_note_id].y -  notesHigh) * errorTolerance
        local time = self.speed * (self.rangeTime / self.compass.divisor)
        if (errorHit < time) then
            if (errorHit < perfect_percent * time) then
                self.msg = "perfect!"
                self.points = self.points + perfect_ponits
            elseif (errorHit < good_percent * time) then 
                self.msg = "good!"
                self.points = self.points + good_points
            else
                self.msg = "bad!"
                self.points = self.points + bad_points
            end
            SongPlayer.eliminateNote(self, min_note_id)
            self.countPlayedNotes = self.countPlayedNotes + 1
        end
    end
end

function SongPlayer.eliminateNote(self, i)
    self.notesInScreenSize = self.notesInScreenSize - 1                
    for j=i, self.notesInScreenSize do
        self.notesInScreenVector[j].x = self.notesInScreenVector[j+1].x
        self.notesInScreenVector[j].y = self.notesInScreenVector[j+1].y
        self.notesInScreenVector[j].key = self.notesInScreenVector[j+1].key
    end
end

function SongPlayer.update(self, dt)
    -- Espera a leer el archivo completo
    --[[
        ...
    ]]

    -- Espera el desfase inicial
    if (not self.songPlaying) then 
        if (self.initCounter >= self.offset) then
            self.songPlaying = true
            love.audio.play(self.music)
        else
            self.initCounter = self.initCounter + dt
        end
    end
 
    -- Calcula cuando poner la siguiente nota
    self.timerCounter = self.timerCounter + dt
    if (self.timerCounter >= (self.rangeTime / self.compass.divisor)) then
        if not self.endSong then
            local getNoteOrEnd = false
            while (not getNoteOrEnd) do
                getNoteOrEnd = SongPlayer.interpretLine(self)
                --getNoteOrEnd = SongInterpreter.interpretLine(self.interpreter)
            end
        end
        self.timerCounter = self.timerCounter - (self.rangeTime / self.compass.divisor)
    end

    --Chequea si se van de largo las notas
    for i=1, self.notesInScreenSize  do
        self.notesInScreenVector[i].y = self.notesInScreenVector[i].y + self.speed * dt
        if (self.notesInScreenVector[i].y >= (love.graphics.getHeight() + noteRadius * 2)) then 
            self.msg = "miss!"
            self.points = self.points + miss_points
            SongPlayer.eliminateNote(self, i)
        end
    end

    --Chequea si se va de largo la linea de compas
    for i=1, self.compassLineSize do
        self.compassLine[i].y = self.compassLine[i].y + self.speed * dt
        if (self.compassLine[i].y >= (love.graphics.getHeight() + 70)) then 
            SongPlayer.eliminateCompassLine(self, i)
        end
    end

    for i = 1, self.nKeys do
        Key.update(keys[i], dt, i, key_notes[i + #key_notes - self.nKeys][1])
    end
end

function SongPlayer.draw(self)
    love.graphics.setColor(1,1,1,1)

    love.graphics.print(self.msg, 300, 100, 0, 3, 3)
    love.graphics.print("bpm = " .. self.bpm, 100, 200, 0, 2, 2) 
    love.graphics.print("speed = " .. self.speed, 100, 300, 0, 2, 2)
    love.graphics.print("points = " .. self.points , 100, 400, 0, 2, 2)

    for i=1, self.compassLineSize do
        love.graphics.line(750, self.compassLine[i].y , 1200, self.compassLine[i].y)
        love.graphics.print(self.compassLine[i].text, 630, self.compassLine[i].y - 70, 0, 5, 5)
    end

    for i=1, self.notesInScreenSize do
        -- draw note
        love.graphics.line(self.notesInScreenVector[i].x - lineNoteWidth, self.notesInScreenVector[i].y, self.notesInScreenVector[i].x + lineNoteWidth, self.notesInScreenVector[i].y)
        love.graphics.circle('fill', self.notesInScreenVector[i].x, self.notesInScreenVector[i].y, noteRadius)
    end

    for i=1, self.nKeys do 
        Key.draw(keys[i])
    end
end

function SongPlayer.stopSong(self)
    love.audio.stop(self.music)
end

function SongPlayer.checkKey(self, key)
    for i = 1, self.nKeys do 
        if (key == key_notes[i + #key_notes - self.nKeys][1]) then
            SongPlayer.checkNote(self, i)
            Key.playSound(keys[i])
        end
    end 
end

return SongPlayer
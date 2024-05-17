SongInterpreter = require "SongInterpreter"
local SongPlayer = {}

local errorTolerance = 0.5
local perfect_percent = 0.2
local good_percent = 0.6

local perfect_ponits = 0
local good_points = -2.5
local bad_points = -10
local miss_points = -50

local noteRadius = 15

local endSong = false

function SongPlayer.init()
    local self = {
        
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
    }
    
    return self
end

function SongPlayer.new(self, speed, bpm, musicFile, nKeys)
    self.music = love.audio.newSource("songs/" .. musicFile .. ".wav", "static")
    --self.file = assert(io.open("songs/" .. musicFile .. ".lpr", "r"))
    self.speed = speed
    self.bpm = bpm 
    self.rangeTime = 60 * 4 / self.bpm
    self.offset = notesHigh / self.speed
    
    self.nKeys = nKeys
    Key.init(keys, key_notes, nKeys) 

    self.timerCounter = 0

    local getNoteOrEnd = false
    while (not getNoteOrEnd) do
        getNoteOrEnd = SongInterpreter.interpretLine(self, self.compass, self.endSong)
    end
end

function SongPlayer.createNewNote(self, i)
    self.notesInScreenSize = self.notesInScreenSize + 1
    self.notesInScreenVector[self.notesInScreenSize] = {}
    self.notesInScreenVector[self.notesInScreenSize].y = 0
    self.notesInScreenVector[self.notesInScreenSize].x = keys[i].x
    self.notesInScreenVector[self.notesInScreenSize].key = i
end

function SongPlayer.createCompassLine(self, withMsg, isThick)
    self.compassLineSize = self.compassLineSize + 1
    self.compassLine[self.compassLineSize] = {}
    self.compassLine[self.compassLineSize].y = 0
    self.compassLine[self.compassLineSize].isThick = isThick
    if withMsg then 
        self.compassLine[self.compassLineSize].text = self.compass.msg
    else 
        self.compassLine[self.compassLineSize].text = ""
    end
end

function SongPlayer.eliminateCompassLine(self, i)
    self.compassLineSize = self.compassLineSize - 1                
    for j=i, self.compassLineSize do
        self.compassLine[j].y = self.compassLine[j+1].y
        self.compassLine[j].text = self.compassLine[j+1].text
        self.compassLine[j].isThick = self.compassLine[j+1].isThick
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
        local oldDivisor = self.compass.divisor
        if not self.endSong then
            local getNoteOrEnd = false
            while (not getNoteOrEnd) do
                getNoteOrEnd = SongInterpreter.interpretLine(self, self.compass, self.endSong)
                --getNoteOrEnd = SongInterpreter.interpretLine(self.interpreter)
            end
        end
        self.timerCounter = self.timerCounter - (self.rangeTime / oldDivisor)
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
        if self.compassLine[i].isThick then 
            love.graphics.setColor(1,1,1,1)
        else
            love.graphics.setColor(0.1,0.1,0.1,1)
        end
        love.graphics.line(key_notes[#key_notes - self.nKeys + 1][2] - 50, self.compassLine[i].y , 1200, self.compassLine[i].y)
        love.graphics.print(self.compassLine[i].text, key_notes[#key_notes - self.nKeys + 1][2] - 190, self.compassLine[i].y - 70, 0, 5, 5)
    end

    love.graphics.setColor(1,1,1,1)
    for i=1, self.notesInScreenSize do
        -- draw note
        love.graphics.line(self.notesInScreenVector[i].x - lineNoteWidth, self.notesInScreenVector[i].y, self.notesInScreenVector[i].x + lineNoteWidth, self.notesInScreenVector[i].y)
        love.graphics.circle('fill', self.notesInScreenVector[i].x, self.notesInScreenVector[i].y, noteRadius)
    end

    for i=1, self.nKeys do 
        Key.draw(keys[i])
    end

    local time = self.speed * (self.rangeTime / self.compass.divisor) / errorTolerance
    local x = 850
    local w = 350
    love.graphics.setColor(1,0,0,0.2)
    love.graphics.rectangle('fill', x, notesHigh - time, w, time * 2)
    love.graphics.setColor(1,1,0,0.2)
    love.graphics.rectangle('fill', x, notesHigh - time * good_percent, w, time * good_percent * 2)
    love.graphics.setColor(0,1,0,0.2)
    love.graphics.rectangle('fill', x, notesHigh - time * perfect_percent, w, time * perfect_percent * 2)
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

function SongPlayer.keypressed(self, key)
    if key == "escape" then
        gameState["running"] = false
        gameState["songsMenu"] = true
        SongPlayer.stopSong(self)
    else
        SongPlayer.checkKey(song, key)
    end
end

return SongPlayer
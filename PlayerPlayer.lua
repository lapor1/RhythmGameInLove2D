local Key = require "Key"
local PlayerPlayer = {}

local perfect_area = 10
local good_area = 25
local bad_area = 40

local perfect_points = 0
local good_points = -2.5
local bad_points = -10
local miss_points = -50

local noteRadius = 15

function PlayerPlayer.new(speed, bpm, nKeys, player, i)
    local self = {
        speed = speed,
        bpm = bpm, 
        rangeTime = 60 * 4 / bpm, 
        timerCounter = 0,

        nKeys = nKeys,
        
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

        countPlayedNotes = 0,
        points = 1000,

        keysData = player.keys,
        xCoord = player.xCoord,
        xData = player.xData,
        keys = Key.init(player.keys, nKeys, i),

        endSong = false,
    }
    return self
end

function PlayerPlayer.init(self, file)
    SongInterpreter.interpretLine(file, self)
end

function PlayerPlayer.createNewNote(self, i)
    self.notesInScreenSize = self.notesInScreenSize + 1
    self.notesInScreenVector[self.notesInScreenSize] = {}
    self.notesInScreenVector[self.notesInScreenSize].y = 0
    self.notesInScreenVector[self.notesInScreenSize].x = self.keys[i].x
    self.notesInScreenVector[self.notesInScreenSize].key = i
end

function PlayerPlayer.createCompassLine(self, withMsg, isThick)
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

function PlayerPlayer.eliminateCompassLine(self, i)
    self.compassLineSize = self.compassLineSize - 1                
    for j=i, self.compassLineSize do
        self.compassLine[j].y = self.compassLine[j+1].y
        self.compassLine[j].text = self.compassLine[j+1].text
        self.compassLine[j].isThick = self.compassLine[j+1].isThick
    end
end

function PlayerPlayer.checkNote(self, key)
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
        local errorHit = math.abs(self.notesInScreenVector[min_note_id].y -  notesHigh)
        if (errorHit < self.rangeTime * bad_area) then
            if (errorHit < perfect_area * self.rangeTime) then
                self.msg = "perfect!"
                self.points = self.points + perfect_points
            elseif (errorHit < good_area * self.rangeTime) then 
                self.msg = "good!"
                self.points = self.points + good_points
            else
                self.msg = "bad!"
                self.points = self.points + bad_points
            end
            PlayerPlayer.eliminateNote(self, min_note_id)
            self.countPlayedNotes = self.countPlayedNotes + 1
        end
    end
end

function PlayerPlayer.eliminateNote(self, i)
    self.notesInScreenSize = self.notesInScreenSize - 1                
    for j=i, self.notesInScreenSize do
        self.notesInScreenVector[j].x = self.notesInScreenVector[j+1].x
        self.notesInScreenVector[j].y = self.notesInScreenVector[j+1].y
        self.notesInScreenVector[j].key = self.notesInScreenVector[j+1].key
    end
end

function PlayerPlayer.update(self, file, dt)
    -- Calcula cuando poner la siguiente nota
    self.timerCounter = self.timerCounter + dt
    if (self.timerCounter >= (self.rangeTime / self.compass.divisor)) then
        local oldDivisor = self.compass.divisor
        if not self.endSong then
            SongInterpreter.interpretLine(file, self)
        end
        self.timerCounter = self.timerCounter - (self.rangeTime / oldDivisor)
    end
    
    --Chequea si se van de largo las notas
    for i=1, self.notesInScreenSize  do
        self.notesInScreenVector[i].y = self.notesInScreenVector[i].y + self.speed * dt
        if (self.notesInScreenVector[i].y >= (love.graphics.getHeight() + noteRadius * 2)) then 
            self.msg = "miss!"
            self.points = self.points + miss_points
            PlayerPlayer.eliminateNote(self, i)
        end
    end
    
    --Chequea si se va de largo la linea de compas
    for i=1, self.compassLineSize do
        self.compassLine[i].y = self.compassLine[i].y + self.speed * dt
        if (self.compassLine[i].y >= (love.graphics.getHeight() + 70)) then 
            PlayerPlayer.eliminateCompassLine(self, i)
        end
    end
    
    for i = 1, self.nKeys do
        --Key.update(self.keys[i], dt, i, self.keysData[i + #self.keysData - self.nKeys][1])
        Key.update(self.keys[i], dt, i, self.keysData[i][1])
    end
end

function PlayerPlayer.draw(self)
    love.graphics.setColor(1,1,1,1)

    love.graphics.print(self.msg, self.xData, 100, 0, 3, 3)
    love.graphics.print("bpm = " .. self.bpm, self.xData, 200, 0, 2, 2) 
    love.graphics.print("speed = " .. self.speed, self.xData, 300, 0, 2, 2)
    love.graphics.print("points = " .. self.points , self.xData, 400, 0, 2, 2)

    for i=1, self.compassLineSize do
        if self.compassLine[i].isThick then 
            love.graphics.setColor(1,1,1,1)
        else
            love.graphics.setColor(0.1,0.1,0.1,1)
        end
        --love.graphics.line(self.xCoord + self.keysData[#self.keysData - self.nKeys + 1][2] - 50, self.compassLine[i].y ,self.xCoord + 400, self.compassLine[i].y)
        --love.graphics.print(self.compassLine[i].text, self.xCoord + self.keysData[#self.keysData - self.nKeys + 1][2] - 190, self.compassLine[i].y - 70, 0, 5, 5)
        love.graphics.line(self.xCoord + self.keysData[1][2] - 50, self.compassLine[i].y ,self.xCoord + 400, self.compassLine[i].y)
        love.graphics.print(self.compassLine[i].text, self.xCoord + self.keysData[1][2] - 190, self.compassLine[i].y - 70, 0, 5, 5)
    end

    love.graphics.setColor(1,1,1,1)
    for i=1, self.notesInScreenSize do
        -- draw note
        love.graphics.line(self.notesInScreenVector[i].x - lineNoteWidth, self.notesInScreenVector[i].y, self.notesInScreenVector[i].x + lineNoteWidth, self.notesInScreenVector[i].y)
        love.graphics.circle('fill', self.notesInScreenVector[i].x, self.notesInScreenVector[i].y, noteRadius)
    end

    for i=1, self.nKeys do 
        Key.draw(self.keys[i])
    end

    love.graphics.setColor(1,0,0,0.2)
    love.graphics.rectangle('fill', self.xCoord + 50, notesHigh - self.rangeTime * bad_area, 350, self.rangeTime * bad_area * 2)
    love.graphics.setColor(1,1,0,0.2)
    love.graphics.rectangle('fill', self.xCoord + 50, notesHigh - self.rangeTime * good_area, 350, self.rangeTime * good_area * 2)
    love.graphics.setColor(0,1,0,0.2)
    love.graphics.rectangle('fill', self.xCoord + 50, notesHigh - self.rangeTime * perfect_area, 350, self.rangeTime * perfect_area * 2)
end

function PlayerPlayer.checkKey(self, key)
    for i = 1, self.nKeys do 
        --if (key == self.keysData[i + #self.keysData - self.nKeys][1]) then
        if (key == self.keysData[i][1]) then
        PlayerPlayer.checkNote(self, i)
            --Key.playSound(self.keys[i])
        end
    end 
end

return PlayerPlayer
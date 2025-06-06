local exports = exports or {}
local SeekModeScript = SeekModeScript or {}
SeekModeScript.__index = SeekModeScript

local fps = 30.0
local uScales = {1,1.07,1.1,1.13,1.17,1.2,1.2,1,1,1,1,1,1,1,1}
local uScaleSize = #uScales

function SeekModeScript.new(construct, ...)
    local self = setmetatable({}, SeekModeScript)
    if construct and SeekModeScript.constructor then SeekModeScript.constructor(self, ...) end
    self.t = 0
    self.speedIntensity = 0.33
    return self
end

function SeekModeScript:constructor()

end

function SeekModeScript:onUpdate(comp, deltaTime)
    self.t = self.t + deltaTime
    self:seekToTime(comp, self.t)
end

function SeekModeScript:start(comp)
    self.material = comp.entity:getComponent("MeshRenderer").material
end

function SeekModeScript:seekToTime(comp, time)
    if self.first == nil then
        self.first = true
        self:start(comp)
    end

    local id = math.floor(time * (0.5 + self.speedIntensity * 1.5)*fps)
    local cur_id = math.mod(id, uScaleSize)+1
    self.material:setFloat("scale", uScales[cur_id])
end

exports.SeekModeScript = SeekModeScript
return exports

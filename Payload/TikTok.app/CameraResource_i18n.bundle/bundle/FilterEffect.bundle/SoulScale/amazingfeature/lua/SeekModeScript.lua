--@input float curTime = 0.0{"widget":"slider","min":0,"max":1}

local exports = exports or {}
local SeekModeScript = SeekModeScript or {}
SeekModeScript.__index = SeekModeScript

local fps = 30.0
local uMixturePercent = {
    0.411498,
    0.340743,
    0.283781,
    0.237625,
    0.199993,
    0.169133,
    0.143688,
    0.122599,
    0.037117,
    0.028870,
    0.022595,
    0.017788,
    0.010000,
    0.010000,
    0.010000,
    0.010000
}
local uScalePercent = {
    1.084553,
    1.173257,
    1.266176,
    1.363377,
    1.464923,
    1.570877,
    1.681300,
    1.796254,
    1.915799,
    2.039995,
    2.168901,
    2.302574,
    2.302574,
    2.302574,
    2.302574,
    2.302574
    }
local uScaleSize = #uScalePercent
local uMixtureSize = #uMixturePercent

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
    self.material:setFloat("mixturePercent", uMixturePercent[cur_id])
    self.material:setFloat("scalePercent", uScalePercent[cur_id])
end

exports.SeekModeScript = SeekModeScript
return exports

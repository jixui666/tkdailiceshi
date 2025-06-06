local exports = exports or {}
local filter = filter or {}
filter.__index = filter

function filter.new(construct, ...)
    local self = setmetatable({}, filter)
    self.filterMaterial = nil
    return self
end

function filter:onStart(component)
    -- Amaz.LOGI("filter", "filter:onStart")

    -- disable irrelevant event
    local scriptSys = component.entity.scene:getSystem("ScriptSystem")
    scriptSys:clearAllEventType()
    scriptSys:addEventType(Amaz.BEFEventType.BET_COMPOSER)

    -- disable depth rt
    local output_rt = component.entity.scene:getOutputRenderTexture()
    output_rt.attachment = Amaz.RenderTextureAttachment.NONE

    -- find filter
    self.filterMaterial = component.entity:getComponent("MeshRenderer").material
end

function filter:onEvent(component, event)
    if event.type == Amaz.BEFEventType.BET_COMPOSER then
        if event.args:get(0) == "Filter_intensity" then
            local filterIntensity = event.args:get(2)
            if filterIntensity >= 0.0 and filterIntensity <= 1.0 then
                self:setFilterIntensity(filterIntensity)
            end
        elseif event.args:get(0) == "leftSlidePosition" then
            local leftSlidePosition = event.args:get(2)
            if leftSlidePosition == 0.0 or leftSlidePosition == 1.0 then
                self.filterMaterial:disableMacro("AE_SlidingFilter")
            else
                self.filterMaterial:enableMacro("AE_SlidingFilter", 1)
                self:setActiveArea(0.0, leftSlidePosition)
            end
        elseif event.args:get(0) == "rightSlidePosition" then
            local rightSlidePosition = event.args:get(2)
            if rightSlidePosition == 0.0 or rightSlidePosition == 1.0 then
                self.filterMaterial:disableMacro("AE_SlidingFilter")
            else
                self.filterMaterial:enableMacro("AE_SlidingFilter", 1)
                self:setActiveArea(rightSlidePosition, 1.0)
            end
        end
    end
end

function filter:setFilterIntensity(intensity)
    self.filterMaterial:setFloat("intensity", intensity)
end

function filter:setActiveArea(leftBorder, rightBorder)
    self.filterMaterial:setVec2("activeArea", Amaz.Vector2f(leftBorder, rightBorder))
end

exports.filter = filter
return exports

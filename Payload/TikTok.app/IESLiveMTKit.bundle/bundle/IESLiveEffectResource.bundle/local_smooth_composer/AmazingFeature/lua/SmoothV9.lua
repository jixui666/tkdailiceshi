local exports = exports or {}
local SmoothV9 = SmoothV9 or {}
SmoothV9.__index = SmoothV9

function SmoothV9.new(construct, ...)
    local self = setmetatable({}, SmoothV9)
    self.comps = {}
    self.compsdirty = true

    self.inputTex = nil

    self.commandBufDynamic = Amaz.CommandBuffer()
    self.commandBufStatic = Amaz.CommandBuffer()

    self.kawaseMaterial = nil
    self.kawase3Material = nil
    self.smoothMaterial = nil
    self.smoothMaterialBlock = Amaz.MaterialPropertyBlock()

    self.kawaseRT = nil
    self.kawase3RT = nil
    self.smoothRT = nil

    self.smoothIntensity = 0.0
    self.smoothScaleFactor = 1.0
    self.exclusiveFlag = false

    self.isFrontCamera = true

    return self
end

function SmoothV9:initialize(sys)
    
    local commandTableResources = sys.scene:findEntityBy("SmoothV9"):getComponent("TableComponent")

    -- INPUT0
    self.inputTex = commandTableResources.table:get("input_texture")

    -- material
    self.kawaseMaterial = commandTableResources.table:get("kawase_material")
    self.kawase3Material = commandTableResources.table:get("kawase3_material")
    self.smoothMaterial = commandTableResources.table:get("smooth_material")

    -- render target
    self.kawaseRT = commandTableResources.table:get("kawase_rt")
    self.kawase3RT = commandTableResources.table:get("kawase3_rt")
    self.smoothRT = commandTableResources.table:get("smooth_rt")   --output

    -- disable depth rt
    local outputRT = sys.scene:getOutputRenderTexture()
    outputRT.attachment = Amaz.RenderTextureAttachment.NONE

    -- clear irrelevant events
    local scriptSys = sys.scene:getSystem("ScriptSystem")
    scriptSys:clearAllEventType()
    scriptSys:addEventType(Amaz.BEFEventType.BET_COMPOSER)
    scriptSys:addEventType(Amaz.BEFEventType.BET_EXCLUSIVE)

    -- get camera's default position
    if Amaz.Input:getCameraPosition() == 0 then
        self.isFrontCamera = true
    else
        self.isFrontCamera = false
    end    
end

function SmoothV9:onStart(sys)

    self:initialize(sys)

    -- kawase blur -- pass 1
    self.commandBufStatic:blitWithMaterial(self.inputTex, self.kawaseRT, self.kawaseMaterial, 0, true)

    -- kawase3 blur -- pass 2
    self.commandBufStatic:blitWithMaterial(self.kawaseRT, self.kawase3RT, self.kawase3Material, 0, true)

    -- smooth -- pass 3
    self.smoothMaterial:setTex("blurImageTex", self.kawase3RT)
    self.commandBufStatic:blitWithMaterialAndProperties(self.inputTex, self.smoothRT, self.smoothMaterial, 0, self.smoothMaterialBlock, true)
end

function SmoothV9:onUpdate(sys,deltaTime)
    -- handle the case when been exclusive
    if self.exclusiveFlag then
        -- case 1: been exclusived, simply blit 
        self.commandBufDynamic:clearAll()
        self.commandBufDynamic:blit(self.inputTex, self.smoothRT)
        sys.scene:commitCommandBuffer(self.commandBufDynamic)
        return
    end

    local faceCount = 0
    local result =  Amaz.Algorithm:getAEAlgorithmResult()
    if result ~= nil then
        faceCount = result:getFaceCount()
    end
    -- front and back camera strategy
    if faceCount > 0 then
        self.smoothScaleFactor = 1.0
    else
        if self.isFrontCamera == true then
            self.smoothScaleFactor = 0.6
        else
            self.smoothScaleFactor = 0.0
        end
    end

    -- update uniforms which needs to update
    self.smoothMaterialBlock:setFloat("smoothIntensity", self.smoothIntensity)
    self.smoothMaterialBlock:setFloat("smoothScaleFactor", self.smoothScaleFactor)

    -- handle the case when intensity is zero 
    if self.smoothIntensity > 0.0 then 
        sys.scene:commitCommandBuffer(self.commandBufStatic)
    else
        -- simply blit
        self.commandBufDynamic:clearAll()
        self.commandBufDynamic:blit(self.inputTex, self.smoothRT)
        sys.scene:commitCommandBuffer(self.commandBufDynamic)
    end
end

function SmoothV9:onEvent(sys,event)
    if event.type == Amaz.BEFEventType.BET_COMPOSER then
        if event.args:get(0) == "Smooth_ALL" then
            self.smoothIntensity = 0.85 * event.args:get(2)
        end
    elseif event.type == Amaz.BEFEventType.BET_EXCLUSIVE then
        if event.args:get(0) == "EXCLUSIVE_ALL_PARAM" then
            self.exclusiveFlag = event.args:get(1)
        end
    elseif event.type == Amaz.AppEventType.COMPAT_BEF then
        -- camera position switch event listened
        if event.args:get(0) == Amaz.BEFEventType.BET_CAMERA_SWITCHED then
            if event.args:get(1) == 0 then
                self.isFrontCamera = true
            elseif event.args:get(1) == 1 then
                self.isFrontCamera = false
            end
        end        
    end
end

exports.SmoothV9 = SmoothV9
return exports

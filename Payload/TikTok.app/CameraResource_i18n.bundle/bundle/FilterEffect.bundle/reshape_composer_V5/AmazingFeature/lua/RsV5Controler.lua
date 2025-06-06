local exports = exports or {}
local RsV5Controler = RsV5Controler or {}
RsV5Controler.__index = RsV5Controler

function RsV5Controler.new(construct, ...)
    local self = setmetatable({}, RsV5Controler)
    self.name = "RsV5Controler"
    self.comps = {}
    self.compCount = 0
    self.compsdirty = true
    self.organName = {
            "DISTORTION_V3_NEW_QINGYAN_FAR_EYE", 
            "DISTORTION_V3_NEW_QINGYAN_ZOOM_EYE",
            "DISTORTION_V3_NEW_QINGYAN_ROTATE_EYE",
            "DISTORTION_V3_NEW_QINGYAN_MOVE_EYE",
            "DISTORTION_V3_NEW_QINGYAN_ZOOM_NOSE", 
            "DISTORTION_V3_NEW_QINGYAN_MOVE_NOSE",
            "DISTORTION_V3_NEW_QINGYAN_MOVE_MOUTH",
            "DISTORTION_V3_NEW_QINGYAN_ZOOM_MOUTH",
            "DISTORTION_V3_NEW_QINGYAN_MOVE_CHIN",
            "DISTORTION_V3_NEW_QINGYAN_ZOOM_FOREHEAD",
            "DISTORTION_V3_NEW_QINGYAN_ZOOM_FACE",
            "DISTORTION_V3_NEW_QINGYAN_CUT_FACE",
            "DISTORTION_V3_NEW_QINGYAN_SMALL_FACE",
            "DISTORTION_V3_NEW_QINGYAN_ZOOM_JAW_BONE",
            "DISTORTION_V3_NEW_QINGYAN_ZOOM_CHEEK_BONE",
            "DISTORTION_V3_NEW_QINGYAN_DRAG_LIPS",
            "DISTORTION_V3_NEW_QINGYAN_CORNER_EYE",
            "DISTORTION_V3_NEW_QINGYAN_LIP_ENHANCE",
            "DISTORTION_V3_NEW_QINGYAN_POINTY_CHIN",
            "DISTORTION_V3_NEW_QINGYAN_TEMPLE",
            "Eye_Type",
            "DISTORTION_V3_NEW_QINGYAN_VFACE"
    }

    self.organParam = {
        0.08,
        -0.2,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        -0.2, --11-
        0,    --12-
        -0.1, --13-
        0,
        0,
        0,
        0,
        0,
        0,
        -0.2,
        2,
        0
    }
    

    self.paramNameMap = {
            DISTORTION_V3_NEW_QINGYAN_FAR_EYE = 0,
            DISTORTION_V3_NEW_QINGYAN_ZOOM_EYE = 1,
            DISTORTION_V3_NEW_QINGYAN_ROTATE_EYE = 2,
            DISTORTION_V3_NEW_QINGYAN_MOVE_EYE = 3,
            DISTORTION_V3_NEW_QINGYAN_ZOOM_NOSE = 4,
            DISTORTION_V3_NEW_QINGYAN_MOVE_NOSE = 5,
            DISTORTION_V3_NEW_QINGYAN_MOVE_MOUTH = 6,
            DISTORTION_V3_NEW_QINGYAN_ZOOM_MOUTH = 7,
            DISTORTION_V3_NEW_QINGYAN_MOVE_CHIN = 8,
            DISTORTION_V3_NEW_QINGYAN_ZOOM_FOREHEAD = 9,
            DISTORTION_V3_NEW_QINGYAN_ZOOM_FACE = 10,
            DISTORTION_V3_NEW_QINGYAN_CUT_FACE = 11,
            DISTORTION_V3_NEW_QINGYAN_SMALL_FACE = 12,
            DISTORTION_V3_NEW_QINGYAN_ZOOM_JAW_BONE = 13,
            DISTORTION_V3_NEW_QINGYAN_ZOOM_CHEEK_BONE = 14,
            DISTORTION_V3_NEW_QINGYAN_DRAG_LIPS = 15,
            DISTORTION_V3_NEW_QINGYAN_CORNER_EYE = 16,
            DISTORTION_V3_NEW_QINGYAN_LIP_ENHANCE = 17,
            DISTORTION_V3_NEW_QINGYAN_POINTY_CHIN = 18,
            DISTORTION_V3_NEW_QINGYAN_TEMPLE = 19,
            Eye_Type = 20,
            DISTORTION_V3_NEW_QINGYAN_VFACE = 21
    }

    self.intensityMap = {
            DISTORTION_V3_NEW_QINGYAN_FAR_EYE = 0.0,
            DISTORTION_V3_NEW_QINGYAN_ZOOM_EYE = 0.0,
            DISTORTION_V3_NEW_QINGYAN_ROTATE_EYE = 0.0,
            DISTORTION_V3_NEW_QINGYAN_MOVE_EYE = 0.0,
            DISTORTION_V3_NEW_QINGYAN_ZOOM_NOSE = 0.0,
            DISTORTION_V3_NEW_QINGYAN_MOVE_NOSE = 0.0,
            DISTORTION_V3_NEW_QINGYAN_MOVE_MOUTH = 0.0,
            DISTORTION_V3_NEW_QINGYAN_ZOOM_MOUTH = 0.0,
            DISTORTION_V3_NEW_QINGYAN_MOVE_CHIN = 0.0,
            DISTORTION_V3_NEW_QINGYAN_ZOOM_FOREHEAD = 0.0,
            DISTORTION_V3_NEW_QINGYAN_ZOOM_FACE = -0.0,
            DISTORTION_V3_NEW_QINGYAN_CUT_FACE = 0.0,
            DISTORTION_V3_NEW_QINGYAN_SMALL_FACE = 0.0,
            DISTORTION_V3_NEW_QINGYAN_ZOOM_JAW_BONE = 0.0,
            DISTORTION_V3_NEW_QINGYAN_ZOOM_CHEEK_BONE = 0.0,
            DISTORTION_V3_NEW_QINGYAN_DRAG_LIPS = 0.0,
            DISTORTION_V3_NEW_QINGYAN_CORNER_EYE = 0.0,
            DISTORTION_V3_NEW_QINGYAN_LIP_ENHANCE = 0.0,
            DISTORTION_V3_NEW_QINGYAN_POINTY_CHIN = 0.0,
            DISTORTION_V3_NEW_QINGYAN_TEMPLE = 0.0,
            DISTORTION_V3_NEW_QINGYAN_VFACE = 0.0
    }

    self.intensityMapCache = nil

    self.faceVal = 0.0
    self.eyeVal = 0.0

    self.faceDeformationNeedUpdate = true
    self.camera = nil
    self.clearCameraEnt = nil
    self.blitEnt = nil
    self.hasInputTexture = true
    self.isDrawFaceEntity = false

    return self
end

function RsV5Controler:constructor()
    -- print('running: RsV5Controler:constructor')
end

function RsV5Controler:onComponentAdded(sys, comp)
    if comp:isInstanceOf('FaceReshape') then
        self.comps[self.compCount] = comp
        self.compCount = self.compCount + 1
        self.compsdirty = true;
    end
    -- print('running: RsV5Controler:onComponentAdded'..self.compCount)
end

function RsV5Controler:onComponentRemoved(sys, comp)
    if comp:isInstanceOf('FaceReshape') and self.compCount > 0 then
        self.comps[self.compCount - 1] = nil;
        table.remove(self.comps, self.compCount - 1)
        self.compCount = self.compCount - 1
    end
    -- print('running: RsV5Controler:onComponentRemoved')
end

function RsV5Controler:onStart(sys)
    self.scene = sys.scene

    local output_rt = self.scene:getOutputRenderTexture()
    output_rt.attachment = Amaz.RenderTextureAttachment.NONE

    local cameraEntity = self.scene:findEntityBy("Camera_entity")
    if cameraEntity ~= nil then 
        self.camera = cameraEntity:getComponent("Camera")
    end
    self.clearCameraEnt = self.scene:findEntityBy("Camera")
    self.blitEnt = self.scene:findEntityBy("Blit")
    
    local scriptSys = self.scene:getSystem("ScriptSystem")
    scriptSys:clearAllEventType()
    scriptSys:addEventType(Amaz.BEFEventType.BET_COMPOSER)
    scriptSys:addEventType(Amaz.BEFEventType.BET_EXCLUSIVE)

    self.path = self.scene.assetMgr.rootDir
    self.materialSingle = self.scene.assetMgr:SyncLoad(self.path .. "material/FaceDistortionV5Material1.material")
    self.materialMultiy = self.scene.assetMgr:SyncLoad(self.path .. "material/FaceDistortionV5Material0.material")

    self.singlePer = false
    self.multiPer = false
    local algRes = Amaz.Algorithm.getAEAlgorithmResult()
    self.person_count = algRes:getFaceCount()
    if self.person_count > 1 then
        self.multiPer = true
        for i = 0, self.compCount - 1, 1 do
            self.comps[i].entity:getComponent("MeshRenderer").material = self.materialMultiy
        end
    elseif self.person_count <= 1 then
        self.singlePer = true
    end

    -- print('running: RsV5Controler:onStart')
end

function RsV5Controler:onUpdate(sys,deltaTime)
    local algRes = Amaz.Algorithm.getAEAlgorithmResult()
    self.person_count = algRes:getFaceCount()
    if self.person_count > 1 and self.singlePer == true then
        for i = 0, self.compCount - 1, 1 do
            self.comps[i].entity:getComponent("MeshRenderer").sharedMaterial = self.materialMultiy
        end
        self.singlePer = false
        self.multiPer = true
    elseif self.person_count <= 1 and self.multiPer == true then
        for i = 0, self.compCount - 1, 1 do
            self.comps[i].entity:getComponent("MeshRenderer").sharedMaterial = self.materialSingle
        end
        self.singlePer = true
        self.multiPer = false
    end

    -- print('person count: '..self.person_count)

    if self.person_count <= 0 or self.person_count > 1 then 
        if not self.hasInputTexture then
            self.clearCameraEnt.visible = true
            self.blitEnt.visible = true
            self.camera.clearType = Amaz.CameraClearType.DONT
            self.hasInputTexture = true
        end
    elseif self.hasInputTexture then 
        self.clearCameraEnt.visible = false
        self.blitEnt.visible = false
        self.camera.clearType = Amaz.CameraClearType.COLOR
        self.hasInputTexture = false
    end

    if self.faceDeformationNeedUpdate then
        for i = 0, self.compCount - 1, 1 do
            local isAllZero = true;
            local intensities = self.comps[i].params.degrees
            
            for key, value in pairs(self.intensityMap) do
                intensities:set(self.paramNameMap[key], value)
                if math.abs(value) ~= 0.0 then
                    isAllZero = false
                end
            end

            self.comps[i].params.degrees = intensities

            if isAllZero then
                self.comps[i].entity.visible = false
                self.isDrawFaceEntity = false
            else
                self.comps[i].entity.visible = true
                self.isDrawFaceEntity = true
            end
        end
        self.faceDeformationNeedUpdate = false
    end

    if not self.isDrawFaceEntity and not self.hasInputTexture then
        -- draw background
        self.clearCameraEnt.visible = true
        self.blitEnt.visible = true
        self.camera.clearType = Amaz.CameraClearType.DONT
        self.hasInputTexture = true
    end
    -- print('running: RsV5Controler:onUpdate')
end

function RsV5Controler:onEvent(sys, event)
    if event.type == Amaz.BEFEventType.BET_COMPOSER then
    
        local tag = event.args:get(0)
        local path = event.args:get(1)
        local value = event.args:get(2)

        if tag == "Face_ALL" then
            self.faceVal = value
            self.faceDeformationNeedUpdate = true
        elseif tag == "Eye_ALL" then
            self.eyeVal = value
            self.faceDeformationNeedUpdate = true
        end

        if self.faceDeformationNeedUpdate then
            self:setIntensity(self.organName[1], self.faceVal * self.organParam[1])
            self:setIntensity(self.organName[11], self.faceVal * self.organParam[11])
            self:setIntensity(self.organName[13], (self.faceVal * 0.1) * self.organParam[13])
            self:setIntensity(self.organName[20], self.faceVal * self.organParam[20])
    
            self:setIntensity(self.organName[2], -self.eyeVal * self.organParam[2])
        end
    elseif event.type == Amaz.BEFEventType.BET_EXCLUSIVE then
            local exclusiveTag = event.args:get(0)
            local exclusive = event.args:get(1)
            if exclusiveTag ~= "EXCLUSIVE_ALL_PARAM" then
                if self.intensityMap[exclusiveTag] ~= nil then
                    if exclusive then
                        if self.intensityMapCache == nil then
                            self.intensityMapCache = {}
                        end
                        if self.intensityMapCache[exclusiveTag] == nil then
                            self.intensityMapCache[exclusiveTag] = self.intensityMap[exclusiveTag]
                            self.intensityMap[exclusiveTag] = 0
                            self.faceDeformationNeedUpdate = true
                        end
                    else
                        if self.intensityMapCache ~= nil and self.intensityMapCache[exclusiveTag] ~= nil then
                            self.intensityMap[exclusiveTag] = self.intensityMapCache[exclusiveTag]
                            self.intensityMapCache[exclusiveTag] = nil
                            self.faceDeformationNeedUpdate = true
                        end
                    end
                end
            else
                if exclusive then
                    if self.intensityMapCache == nil then
                        self.intensityMapCache = {}
                    end
                    if self.intensityMap ~= nil then
                        if self.intensityMap[exclusiveTag] ~= nil then
                            self.intensityMapCache[exclusiveTag] = self.intensityMap[exclusiveTag]
                            self.intensityMap[exclusiveTag] = 0
                            self.faceDeformationNeedUpdate = true
                        end
                    end
                else
                    if self.intensityMapCache ~= nil then
                        for key, value in pairs(self.intensityMapCache) do
                            if value ~= nil then
                                self.intensityMap[key] = value
                                self.faceDeformationNeedUpdate = true;
                            end
                        end
                        self.intensityMapCache = nil;
                    end
                end
            end
        end
end

function RsV5Controler:setIntensity(params, value)
    if self.intensityMapCache ~= nil and self.intensityMapCache[params] ~= nil then
        self.intensityMapCache[params] = value
    else
        self.intensityMap[params] = value
    end
end

function RsV5Controler:onDestroy()
    self.camera = nil
    self.clearCameraEnt = nil
    self.blitEnt = nil
    self.scene = nil
end

exports.RsV5Controler = RsV5Controler
return exports

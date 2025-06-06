local faceVal = 0.0
local eyeVal = 0.0

EventHandles = 
{
    handleComposerUpdateNodeEvent = function (this, path, tag, percentage)
        local feature = this:getFeature("AmazingFeature")
        if not feature then
            return false
        end

        if feature:getType() ~= "FaceReshapeAmazingFeature" then
            return false
        end

        if tag == "Face_ALL" then
            faceVal = percentage
        elseif tag == "Eye_ALL" then
            eyeVal = percentage
        end

        if math.abs(faceVal) == 0.0 and math.abs(eyeVal) == 0.0 then
            feature:setFeatureStatus(EffectSdk.BEF_FEATURE_STATUS_ENABLED, false)
            Amaz.Algorithm.setAlgorithmEnable(this:getName(), "face_0", false)
        else
            feature:setFeatureStatus(EffectSdk.BEF_FEATURE_STATUS_ENABLED, true)
            Amaz.Algorithm.setAlgorithmEnable(this:getName(), "face_0", true)
        end

        return true
    end
}
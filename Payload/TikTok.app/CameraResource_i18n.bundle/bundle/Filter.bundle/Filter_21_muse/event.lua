local filterIntensity = 1.0

local CommonFunc = {
    setFeatureEnabled = function(this, path, status)
        local feature = this:getFeature(path)
        if (feature) then
            feature:setFeatureStatus(EffectSdk.BEF_FEATURE_STATUS_ENABLED, status)
        end
    end
}

EventHandles = {
    handleComposerUpdateNodeEvent = function (this, path, tag, percentage)       
        if  tag == "Filter_intensity" then
            filterIntensity = percentage
            if filterIntensity == 0.0 then
                CommonFunc.setFeatureEnabled(this, "AmazingFeature", false)
            else
                CommonFunc.setFeatureEnabled(this, "AmazingFeature", true)
            end
        end
    end
}
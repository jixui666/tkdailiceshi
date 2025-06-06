
const effect_api = "undefined" != typeof effect ? effect : "undefined" != typeof tt ? tt : "undefined" != typeof lynx ? lynx : {};
const Amaz = effect_api.getAmaz();

class filter {
    constructor() {
        this.name = "filter";
    }
    onEnable(){
        //console.log("[OnEnable]",this.name);
    }

    onStart() {
        let curJSScriptSystem = this.scene.getSystem("JSScriptSystem")
        curJSScriptSystem.clearAllEventType()
        curJSScriptSystem.addEventType(Amaz.AppEventType.COMPAT_BEF)
        
        let output_rt = this.scene.getOutputRenderTexture()
        output_rt.attachment = Amaz.RenderTextureAttachment.NONE

        this.filterMaterial = this.scene.findEntityBy("FilterEntity").getComponent("MeshRenderer").material
    }

    onUpdate(deltaTime) {

    }

    onLateUpdate(deltaTime) {
    }

    onEvent(event) {
        if (event.type == Amaz.AppEventType.COMPAT_BEF) { 
            // args: tag, path, value
            let tagName = event.args.get(0)
            
            if (tagName == "Filter_intensity"){ 
                let path = event.args.get(1)
                let value = event.args.get(2)
                if (value >= 0.0 && value <= 1.0)
                {
                   this.setFilterIntensity(value) 
                }
            }
            if (tagName == "leftSlidePosition"){
                let path = event.args.get(1)
                let value = event.args.get(2)
                //console.log("filter:SlidePositionLeft: " + value)
                this.setActiveArea(0.0, value, 0.0, 1.0)
            }
            if (tagName == "rightSlidePosition"){
                let path = event.args.get(1)
                let value = event.args.get(2)
                //console.log("filter:SlidePositionRight: " + value)
                this.setActiveArea(value, 1.0, 0.0, 1.0)
            }

        }

    }

    setFilterIntensity(intensity){
        this.filterMaterial.setFloat("intensity", intensity)
    }

    setActiveArea(leftBorder, rightBorder, topBorder, bottomBorder){
        this.filterMaterial.setVec4("activeArea", new Amaz.Vector4f(leftBorder, rightBorder, topBorder, bottomBorder))
    }
}

exports.filter = filter;



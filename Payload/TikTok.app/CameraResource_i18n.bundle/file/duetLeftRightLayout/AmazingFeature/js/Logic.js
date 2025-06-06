'use strict';
const Amaz = effect.Amaz;
const scaleX = 2.0;
const scaleY = 1.0;
const defaultInputWidth = 720;
const defaultInputHeight = 1280;
// const videoInputTextureName = "SRC_USER_TEX_1";
const videoInputTextureName = "MULTISRC_1_0";
const leftCornerVertex = [-1.0, -0.5, 0.0, 0.5]
const rightCornerVertex = [0.0, -0.5, 1.0, 0.5]
const textureScaleX = 0.0;
const textureScaleY = 0.0;
const touchTransform = [2.0, 0.0, 0.0, 
                        0.0, 2.0, 0.0,
                        0.0, -0.5, 1.0];
const switchTouchTransform = [2.0, 0.0, 0.0,
                              0.0, 2.0, 0.0, 
                              -1.0, -0.5, 1.0];
const identityTouchTransform = [1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0];


const SCRIPT_NAME = 'Logic';
class Logic {
  constructor() {
    this.name = SCRIPT_NAME;
    this.videoInputMaterial = null;
    this.videoInputTexture = null;
    this.videoInputTransform = null;
    this.cameraInputTransform = null;
    this.inputWidth = defaultInputWidth;
    this.inputHeight = defaultInputHeight;
    this.outputWidth = defaultInputWidth * scaleX;
    this.outputHeight = defaultInputHeight * scaleY;
    this.layoutSwitch = false;
    this.videoInputOriginalPosition = null;
    this.cameraInputOriginalPosition = null;
    this.videoInputOriginalOrientation = null;
    this.cameraInputOriginalOrientation = null;
    this.objectHeightScale = 1.0;
    this.maskFlag = 1
  }

  /** onEnable is called when the script component is enabled. */
  onEnable() {
    // console.log(this.name, 'onEnable()');
  }

  /** onDisable is called when the script component is disabled. */
  onDisable() {
    // console.log(this.name, 'onDisable()');
  }

  /** onStart is called before the first onUpdate() call. */
  onStart() {
    // console.log(this.name, 'onStart()');
    
    let inputWidth = Amaz.AmazingManager.getSingleton("BuiltinObject").getInputTextureWidth();
    let inputHeight = Amaz.AmazingManager.getSingleton("BuiltinObject").getInputTextureHeight();
    // console.log("@output",`outwidth:${inputWidth} outheight:${inputHeight} inwidth${inputWidth1} inheight${inputHeight1}`)
    if (inputWidth > 0 && inputHeight > 0) {
      this.inputWidth = inputWidth;
      this.inputHeight = inputHeight;
    }
    this.splitMaterial = this.scene.findEntityBy("Blit").getComponent("MeshRenderer").material;
    this.videoInputTexture = Amaz.AmazingManager.getSingleton("BuiltinObject").getUserTexture(videoInputTextureName);
    if (typeof(this.videoInputTexture) == 'undefined' || this.videoInputTexture === null || this.videoInputTexture.width == 0) {
      console.log("@smd","input user video texture is invalid")
    } 
    else {
      this.splitMaterial.setTex("u_VideoTex", this.videoInputTexture);
    }
    // TODO forbid area set；old is null
    // let initForbid = []
    // let forbidList = new Amaz.Vector()
    // let up = new Amaz.Vector4f(initForbid[0], initForbid[1], initForbid[2], initForbid[3])
    // forbidList.pushBack(up)
    // Amaz.AmazingManager.getSingleton("Input").setTouchForbidAreas(forbidList)

    Amaz.AmazingManager.getSingleton("Input").setTouchTransform(new Amaz.Matrix3x3f(touchTransform[0], 
                                                                                    touchTransform[1], 
                                                                                    touchTransform[2],
                                                                                    touchTransform[3],
                                                                                    touchTransform[4],
                                                                                    touchTransform[5],
                                                                                    touchTransform[6],
                                                                                    touchTransform[7],
                                                                                    touchTransform[8],
                                                                                    ));

    

    

    


  }

  /** onUpdate is called once every frame. */
  onUpdate(deltaTime) {
    console.log("EngineType","AmazingFeature");
    this.videoInputTexture = Amaz.AmazingManager.getSingleton("BuiltinObject").getUserTexture(videoInputTextureName);
    if (typeof(this.videoInputTexture) == 'undefined' || this.videoInputTexture === null || this.videoInputTexture.width == 0) {
      console.log("@smd", `input user video texture is invalid`);
      this.splitMaterial.setFloat("isVideo", 0.0);
    } else {
      this.splitMaterial.setTex("u_VideoTex", this.videoInputTexture);
      this.splitMaterial.setFloat("isVideo", 1.0);

    }
    // video record effect
    this.splitMaterial.setFloat("u_maskFlag", this.maskFlag);
    this.splitMaterial.setFloat("videoRatio", this.videoInputTexture.width/this.videoInputTexture.height);


    // Get the ratio of camera input and video input
    // let videoInputWidth = this.videoInputTexture.width;
    // let videoInputHeight = this.videoInputTexture.height;
    // let videoInputRatio = videoInputWidth / videoInputHeight;
    // let inputWidth = Amaz.AmazingManager.getSingleton("BuiltinObject").getInputTextureWidth();
    // let inputHeight = Amaz.AmazingManager.getSingleton("BuiltinObject").getInputTextureHeight();
    // if (inputWidth > 0 && inputHeight > 0) {
    //   this.inputWidth = inputWidth;
    //   this.inputHeight = inputHeight;
    // }
    // let cameraInputRatio = this.inputWidth / this.inputHeight;


    
    // TODO forbid set；
    // let forbid = []
    // if (this.switchButtonVaule == false ) {
    //   for (let index = 0; index < 4; index++) {
    //     forbid.push(leftCornerVertex[index] * 0.5 + 0.5)
    //   }
    // }
    // else{
    //   for (let index = 0; index < 4; index++) {
    //     forbid.push(rightCornerVertex[index] * 0.5 + 0.5)
    //   }
    // }
    // let forbidList = new Amaz.Vector()
    // let up = new Amaz.Vector4f(forbid[0], forbid[1], forbid[2], forbid[3])
    // forbidList.pushBack(up)
    // Amaz.AmazingManager.getSingleton("Input").setTouchForbidAreas(forbidList)
    // switch the layout of camera input & video input if needed
    
    if (this.layoutSwitch != this.switchButtonVaule) {
      this.layoutSwitch = this.switchButtonVaule;
      if (this.switchButtonVaule) {
        this.splitMaterial.setFloat("flipValue", 1.0);
        // console.log("#check setTouchTransform0","before call")                                                                            
        Amaz.AmazingManager.getSingleton("Input").setTouchTransform(new Amaz.Matrix3x3f(switchTouchTransform[0], 
                                                                                        switchTouchTransform[1], 
                                                                                        switchTouchTransform[2],
                                                                                        switchTouchTransform[3],
                                                                                        switchTouchTransform[4],
                                                                                        switchTouchTransform[5],
                                                                                        switchTouchTransform[6],
                                                                                        switchTouchTransform[7],
                                                                                        switchTouchTransform[8],
                                                                                        ));
        // console.log("#check setTouchTransform0","already call")                                                                            
      } else {
        this.splitMaterial.setFloat("flipValue", 0.0);

        // console.log("#check setTouchTransfor1","before call")                                                                            
        Amaz.AmazingManager.getSingleton("Input").setTouchTransform(new Amaz.Matrix3x3f(touchTransform[0], 
                                                                                        touchTransform[1], 
                                                                                        touchTransform[2],
                                                                                        touchTransform[3],
                                                                                        touchTransform[4],
                                                                                        touchTransform[5],
                                                                                        touchTransform[6],
                                                                                        touchTransform[7],
                                                                                        touchTransform[8],
                                                                                        ));
        // console.log("#check setTouchTransfor1","already call")                                                                            
                                                                          
      }
    }
    
  }

  /** onLateUpdate is called once every frame after onUpdate(). */
  onLateUpdate(deltaTime) {
    // console.log(this.name, `onLateUpdate() ${deltaTime}`);
  }

  /** onEvent is called when an event arrives. */
  onEvent(event) {
    // console.log(this.name, 'onEvent()');
    // if (event.type === Amaz.EventType.TOUCH) {
    //   const touch = event.args.get(0);
    //   console.log(this.name, `sdl touch x: ${touch.x}, y: ${touch.y}, type: ${touch.type}`);
    // }
    if (event.args.get(0) === "switchButton" ){
      if (event.args.get(2) === 1) {
        this.switchButtonVaule = true
      }
      else{
        this.switchButtonVaule = false
      }
      // console.log("@smd","switchButton event trigger, value is:" + event.args.get(2))
    }
    if (event.type === Amaz.BEFEventType.BET_EFFECT_COMPAT ){
      let eventType = event.args.get(0)
       if (eventType === Amaz.BEFEventType.BET_RECORD_VIDEO ){
        let eventCode = event.args.get(1)
        if (eventCode === 1) {
          this.maskFlag = 0
        }
        else if (eventCode === 2) {
          this.maskFlag = 1
        }
       }
    }
       
          
           
  }

  /** onDestroy is called when this script instance is destroyed. */
  onDestroy() {
    // console.log(this.name, 'onDestroy()');
    let forbidList = new Amaz.Vector()
    Amaz.AmazingManager.getSingleton("Input").setTouchForbidAreas(forbidList)
    Amaz.AmazingManager.getSingleton("Input").setTouchTransform(new Amaz.Matrix3x3f(identityTouchTransform[0], 
                                                                                    identityTouchTransform[1], 
                                                                                    identityTouchTransform[2],
                                                                                    identityTouchTransform[3],
                                                                                    identityTouchTransform[4],
                                                                                    identityTouchTransform[5],
                                                                                    identityTouchTransform[6],
                                                                                    identityTouchTransform[7],
                                                                                    identityTouchTransform[8],
    ));
    Amaz.AmazingManager.getSingleton("Input").setTouchTransform(new Amaz.Matrix3x3f(identityTouchTransform[0], 
                                                                                    identityTouchTransform[1], 
                                                                                    identityTouchTransform[2],
                                                                                    identityTouchTransform[3],
                                                                                    identityTouchTransform[4],
                                                                                    identityTouchTransform[5],
                                                                                    identityTouchTransform[6],
                                                                                    identityTouchTransform[7],
                                                                                    identityTouchTransform[8],
    ));
  }
}

exports.Logic = Logic;
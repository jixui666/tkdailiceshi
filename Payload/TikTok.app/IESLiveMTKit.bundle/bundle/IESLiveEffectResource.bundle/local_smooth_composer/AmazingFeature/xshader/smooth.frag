// DO_NOT_PATCH_ME
precision mediump float;
varying mediump vec2 textureCoord;

uniform sampler2D _MainTex;
#define srcImageTex _MainTex
uniform sampler2D blurImageTex;

uniform lowp float smoothIntensity;
uniform lowp float smoothScaleFactor;

const float theta = 0.095;

void main()
{
    //firstly, smooth
    lowp vec4 preColor = texture2D(blurImageTex, textureCoord);
    
    lowp vec4 inColor = texture2D(srcImageTex, textureCoord);
    lowp vec3 meanColor = preColor.rgb;
    
    mediump float p = clamp((min(inColor.r, meanColor.r - 0.2) - 0.2)*4.0, 0.0, 1.0); 
    mediump float kMin = (1.0 - preColor.a / (preColor.a + theta)) * p; 

    kMin = kMin * smoothIntensity * smoothScaleFactor;
    lowp vec3 smoothColor = mix(inColor.rgb, meanColor.rgb, kMin);

    gl_FragColor = vec4(smoothColor, inColor.a);
}
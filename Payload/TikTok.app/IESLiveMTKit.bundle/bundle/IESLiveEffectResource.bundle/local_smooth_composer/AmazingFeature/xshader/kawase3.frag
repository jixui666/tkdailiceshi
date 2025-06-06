// DO_NOT_PATCH_ME
precision mediump float;

uniform sampler2D _MainTex;
#define varImageTex _MainTex

varying mediump vec2 textureCoord;

varying mediump vec4 texBlurShift1;
varying mediump vec4 texBlurShift2;
varying mediump vec4 texBlurShift3;
varying mediump vec4 texBlurShift4;

void main()
{
    lowp vec4 color = texture2D(varImageTex, textureCoord);
    mediump vec4 sum = color;
    sum += texture2D(varImageTex, texBlurShift1.xy);
    sum += texture2D(varImageTex, texBlurShift1.zw);
    sum += texture2D(varImageTex, texBlurShift2.xy);
    sum += texture2D(varImageTex, texBlurShift2.zw);
    sum += texture2D(varImageTex, texBlurShift3.xy);
    sum += texture2D(varImageTex, texBlurShift3.zw);
    sum += texture2D(varImageTex, texBlurShift4.xy);
    sum += texture2D(varImageTex, texBlurShift4.zw);
    
    //rgb channel for smoothSrcImage, alpha channel for smoothVarImage
    gl_FragColor = sum * 0.1111;
}
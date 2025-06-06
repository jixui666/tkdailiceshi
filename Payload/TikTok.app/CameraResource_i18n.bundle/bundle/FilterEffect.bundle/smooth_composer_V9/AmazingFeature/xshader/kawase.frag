// DO_NOT_PATCH_ME
precision mediump float;

uniform sampler2D _MainTex;
#define srcImageTex _MainTex

varying mediump vec2 textureCoord;

varying mediump vec4 texBlurShift1;
varying mediump vec4 texBlurShift2;

void main()
{
    mediump vec3 sum = texture2D(srcImageTex, textureCoord).rgb;
    mediump vec3 inColor = sum;
    sum += texture2D(srcImageTex, texBlurShift1.xy).rgb;
    sum += texture2D(srcImageTex, texBlurShift1.zw).rgb;
    sum += texture2D(srcImageTex, texBlurShift2.xy).rgb;
    sum += texture2D(srcImageTex, texBlurShift2.zw).rgb;

    mediump vec3 meanColor = sum * 0.2;
    highp vec3 diffColor = (inColor - meanColor) * 7.0;
    diffColor = min(diffColor * diffColor, 1.0);
    gl_FragColor = vec4(meanColor, (diffColor.r + diffColor.g + diffColor.b) * 0.33);
}

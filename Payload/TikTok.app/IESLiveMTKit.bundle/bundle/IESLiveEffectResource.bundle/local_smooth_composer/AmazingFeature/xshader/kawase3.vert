// DO_NOT_PATCH_ME
attribute vec3 attPosition;
attribute vec2 attUV;

uniform float texBlurWidthOffset;
uniform float texBlurHeightOffset;

varying vec2 textureCoord;

varying vec4 texBlurShift1;
varying vec4 texBlurShift2;
varying vec4 texBlurShift3;
varying vec4 texBlurShift4;

void main()
{
    gl_Position = vec4(attPosition, 1.0);
    textureCoord = attUV;
    
    vec2 singleStepOffset = vec2(texBlurWidthOffset, texBlurHeightOffset) * 1.5;
    vec2 singleStepOffset2 = vec2(texBlurWidthOffset, -1.0 * texBlurHeightOffset) * 1.5;
    
    texBlurShift1 = vec4(attUV - singleStepOffset, attUV + singleStepOffset);
    texBlurShift2 = vec4(attUV - 2.0*singleStepOffset, attUV + 2.0*singleStepOffset);
    texBlurShift3 = vec4(attUV - singleStepOffset2, attUV + singleStepOffset2);
    texBlurShift4 = vec4(attUV - 2.0*singleStepOffset2, attUV + 2.0*singleStepOffset2);
}
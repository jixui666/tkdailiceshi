// DO_NOT_PATCH_ME
attribute vec3 attPosition;
attribute vec2 attUV;

uniform float texBlurWidthOffset;
uniform float texBlurHeightOffset;

varying vec2 textureCoord;
varying vec4 texBlurShift1;
varying vec4 texBlurShift2;

void main()
{
    gl_Position = vec4(attPosition, 1.0);
    textureCoord = attUV;
    
    vec2 singleStepOffset = vec2(texBlurWidthOffset, texBlurHeightOffset) * 3.0;
    vec2 singleStepOffset2 = vec2(texBlurWidthOffset, -1.0 * texBlurHeightOffset) * 3.0;
    
    texBlurShift1 = vec4(attUV - singleStepOffset, attUV + singleStepOffset);
    texBlurShift2 = vec4(attUV - singleStepOffset2, attUV + singleStepOffset2);
}
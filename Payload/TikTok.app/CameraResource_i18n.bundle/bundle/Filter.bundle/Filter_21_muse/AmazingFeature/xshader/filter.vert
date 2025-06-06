precision highp float;

attribute vec2 attPosition;
attribute vec2 attUV;
varying vec2 textureCoordinate;

// DO_NOT_PATCH_ME
void main() 
{ 
    gl_Position = vec4(attPosition.xy, 0.0, 1.0);
    textureCoordinate = attUV.xy;
}

precision highp float;
attribute vec3 attPosition;
attribute vec2 attUV;

varying vec2 uv0;
void main()
{
    gl_Position = vec4(attPosition.x, attPosition.y,0.0,1.0);
    uv0 = attUV;
}
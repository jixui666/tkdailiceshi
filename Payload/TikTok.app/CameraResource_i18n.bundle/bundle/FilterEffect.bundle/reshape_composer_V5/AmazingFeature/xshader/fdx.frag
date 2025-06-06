precision highp float;
varying highp vec2 uv0;
uniform sampler2D u_FBOTexture;

void main()
{
    gl_FragColor = texture2D(u_FBOTexture, uv0);
}
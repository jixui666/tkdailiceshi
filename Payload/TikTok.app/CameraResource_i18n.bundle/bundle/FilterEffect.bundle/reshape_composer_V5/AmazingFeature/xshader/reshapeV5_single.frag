precision highp float;
varying highp vec2 uv0;
uniform sampler2D _tex;

void main()
{
    gl_FragColor = texture2D(_tex, uv0);
}
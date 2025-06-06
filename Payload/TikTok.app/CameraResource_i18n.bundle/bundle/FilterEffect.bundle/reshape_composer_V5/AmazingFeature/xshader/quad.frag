precision lowp float;
varying highp vec2 uv0;
uniform sampler2D u_albedo;
void main()
{
    // DO_NOT_PATCH_ME
    gl_FragColor = texture2D(u_albedo, uv0);
}

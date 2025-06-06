precision highp float;
varying highp vec2 uv0;
uniform sampler2D u_CamTex;
uniform sampler2D u_VideoTex;
uniform float flipValue;
uniform float u_maskFlag;
uniform float videoRatio;
uniform float isVideo;
void main()
{
    vec2 uv1 = vec2(uv0.x*2.0,uv0.y);

    vec2 uv2 = vec2(uv1.x - 1.0,1.0 - uv1.y);
    
    vec2 st1 = mix(uv1,vec2(uv2.x,1.0- uv2.y),flipValue);
    vec2 st2 = mix(uv2,vec2(uv1.x,1.0- uv1.y),flipValue);
    st2.y -= 0.5;
    st2.y *= videoRatio/(9.0/16.0);
    st2.y += 0.5;
    vec4 camCol = texture2D(u_CamTex,st1) ;
    if(st1.x>1.0 || st1.x<0.0 || st1.y>1.0 || st1.y<0.0 )
        camCol = vec4(0.0,0.0,0.0,1.0);
    vec4 videoCol = texture2D(u_VideoTex,st2) ;
    videoCol = mix(videoCol, vec4(0.0, 0.0, 0.0, 1.0), u_maskFlag * 0.3);
    videoCol.rgb *= isVideo;
    if(st2.x>1.0 || st2.x<0.0 || st2.y>1.0 || st2.y<0.0 )
        videoCol = vec4(0.0,0.0,0.0,1.0);
    gl_FragColor = vec4(camCol.rgb + videoCol.rgb,1.0);
}

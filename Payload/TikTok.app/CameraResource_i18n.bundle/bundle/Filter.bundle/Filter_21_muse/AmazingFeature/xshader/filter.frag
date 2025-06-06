precision highp float;
varying lowp vec2 textureCoordinate;

uniform sampler2D VIDEO;
#define inputImageTexture VIDEO

uniform sampler2D LUT;
#define inputImageTexture2 LUT

uniform float intensity;
uniform vec2 activeArea;

// DO_NOT_PATCH_ME
void main()
{
    highp vec4 textureColor1 = texture2D(inputImageTexture, textureCoordinate);
    
    // highp float nonZeroAlpha = step(0.0, -textureColor1.w) * 0.0009765625 + textureColor1.w;
    // highp vec4 unpremultipliedColor1 = vec4(textureColor1.rgb / nonZeroAlpha, textureColor1.w);
    // unpremultipliedColor1 = clamp(unpremultipliedColor1, 0.0, 1.0);

    // textureColor1 = clamp(textureColor1, 0.0, 1.0);

    highp float blueColor = textureColor1.b * 63.0;
    highp float blurColorFloor = floor(blueColor);
    highp float blurColorCeil = ceil(blueColor);
    
    highp vec2 quad1;
    quad1.y = floor(blurColorFloor / 8.0);
    quad1.x = blurColorFloor - (quad1.y * 8.0);
    highp vec2 quad2;
    quad2.y = floor(blurColorCeil / 8.0);
    quad2.x = blurColorCeil - (quad2.y * 8.0);

    highp vec2 texPosOffset =  0.0009765625 + 0.123046875 * textureColor1.rg;
    highp vec2 texPos1 = quad1.xy * 0.125 + texPosOffset;
    highp vec2 texPos2 = quad2.xy * 0.125 + texPosOffset;

    if (textureCoordinate.x >= activeArea.x && textureCoordinate.x <= activeArea.y)
    {
        lowp vec4 newColor2_1 = texture2D(inputImageTexture2, texPos1);
        lowp vec4 newColor2_2 = texture2D(inputImageTexture2, texPos2);
        lowp vec4 newColor22 = mix(newColor2_1, newColor2_2, fract(blueColor));
        gl_FragColor = mix(textureColor1, vec4(newColor22.rgb * textureColor1.w, textureColor1.w), intensity);
    }
    else{
        gl_FragColor = textureColor1;
    }
}

#pragma argument

float rando(float v1, float v2) {
    vec2 co = vec2(v1, v2);
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 srgbToLinear(vec3 vec) {
    float r1 = vec.x;
    if (r1 <= 0.04045) {
        r1 = r1 / 12.92;
    } else {
        r1 = pow((r1 + 0.055) / 1.055, 2.4);
    }
    float g1 = vec.y;
    if (g1 <= 0.04045) {
        g1 = g1 / 12.92;
    } else {
        g1 = pow((g1 + 0.055) / 1.055, 2.4);
    }
    float b1 = vec.z;
    if (b1 <= 0.04045) {
        b1 = b1 / 12.92;
    } else {
        b1 = pow((b1 + 0.055) / 1.055, 2.4);
    }
    return vec3(r1, g1, b1);
}

vec3 rgb2vec3(float r, float g, float b){
    return vec3(r/255., g/255., b/255.);
}
uniform vec3 uColorTwo;
uniform vec3 uColorThree;
uniform float uSpeed;
uniform float uWithNoise; // 1.0 = with noise, 0.0 = no noise
uniform float uColNumber;


#pragma transparent
#pragma body

vec2 coord = _surface.diffuseTexcoord.xy;

// Affection
float time_a = 10.;
float size_a = 0.1;

vec3 uColor1 = rgb2vec3(0., 0., 0.);
vec3 uColor2 = vec3(uColorTwo.x,uColorTwo.y,uColorTwo.z);
vec3 uColor3 = vec3(uColorThree.x, uColorThree.y, uColorThree.z);
vec3 uColor4 = vec3(0., 0., 0.);

vec3 oklab1 = uColor1;
vec3 oklab2 = uColor2;
vec3 oklab3 = uColor3;
vec3 oklab4 = uColor4;
float col = uColNumber;

vec2 st = vec2(coord.x, coord.y);
st.x *= col;

float h = 0.;

float pointA = 0.4;
float pointB = 0.9;

float speed = u_time * (uSpeed) * 0.1 * time_a;

float steper = ceil(st.x) + 0.1;
steper *= cos(speed * 0.1);
vec3 fragColor = vec3(coord.y);

pointA = 0.2 * (floor(st.x + 2.) / col);
coord.y += ((cos(steper) + 2.) * 0.1);

coord.y -= (0.8 * sin(steper * 0.01));
coord.y -= 0.4;
vec3 gradientA = mix(oklab1, oklab2, clamp(coord.y / pointA, 0., 1.));
vec3 gradientB = mix(oklab2, oklab3, clamp((coord.y - pointA) / (pointB - pointA), 0., 1.));
vec3 gradientC = mix(oklab3, oklab4, clamp(1. - (1. - coord.y) / (1. - pointB), 0., 1.));

fragColor = mix(gradientA, gradientB, step(pointA, coord.y));
fragColor = srgbToLinear(mix(fragColor, gradientC, step(pointB, coord.y)));
if (clamp(uWithNoise, 0., 1.) > 0.5 && rando(coord.x * sin(u_time), coord.y * cos(u_time)) > 0.99) {
    fragColor = vec3(0., 0., 0.);
}


float x = _surface.diffuseTexcoord.x;
float y = _surface.diffuseTexcoord.y;
vec2 uv = vec2(x, y);
vec2 center = vec2(0.5, 0.5);



_surface.diffuse = vec4(fragColor,  1.);



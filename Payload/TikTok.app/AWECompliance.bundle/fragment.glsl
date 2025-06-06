#pragma argument


mat2 rotate2d(float angle) {
    return mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
}

float butterFlyC(in float a, in float r, in float count, in float t) {
    // 中心向外四散的图形
    r = r * 0.5;
    float v1 = a * (count) + (t * 0.4);
    float v2 = a * (count) - (t * 0.4);
    float shape = abs(1. - cos(v1)) * sin(v2);
    // 收敛边缘
    float alpha = (1. - smoothstep(shape, shape + 1., r + 0.1 * cos(t)));
    alpha += (1. - smoothstep(shape, shape + 1.4, r + 0.1)) * 0.2;

    return alpha;
}

vec3 RAMP(vec3 cols[4], float x) {
    x *= float(3);
    return mix(cols[int(x)], cols[int(x) + 1], smoothstep(0.0, 1.0, fract(x)));
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


uniform vec4 uColor[3];
uniform vec2 uResolution;
uniform float uScale;
uniform float uSpeed;
uniform float uLightness;
uniform float uMorgh;


#pragma transparent
#pragma body

vec2 coord = _surface.diffuseTexcoord.xy;
//coord.y = coord.y*-0.82 + 1.0;



// Affection
float time_a = 10.;
float size_a = 0.1;

vec2 st = vec2(coord.x, coord.y);


float speed = u_time * (1.4) * 0.05 * time_a;

float x = _surface.diffuseTexcoord.x;
float y = _surface.diffuseTexcoord.y;
vec2 uv = vec2(x, y * 1.6);
vec2 center = vec2(0.5, 0.6);

uv -= center;
uv *= 0.5;
uv *= rotate2d(speed * 0.2);



float r = length(uv) * 0.5;

float a = atan(uv.y/uv.x);
float count = 4.;

vec3 colors[4];
colors[0] =(vec3(0., 0., 0.));
colors[1] =(vec3(59./255.,140./255.,255./255.));
colors[1] -= 0.1;
colors[2] =(vec3(43./255.,45./255.,66./255.));
colors[2] -= 0.1;
colors[3] =(vec3(0., 0., 0.));
vec3 col2 = RAMP(colors, r * 4.);
vec3 shape = vec3(butterFlyC(a, r, count, speed));
vec3 fragColor2 = col2 * (shape);


//fragColor2 = srgbToLinear(fragColor2);
fragColor2 = mix(fragColor2, vec3(0, 0, 0), 0.95);

_surface.diffuse = vec4(fragColor2,  1.);

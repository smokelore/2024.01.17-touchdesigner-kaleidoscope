#define PI 3.141593
#define PI2 6.283185

uniform float time;
//uniform vec2 resolution;
uniform float aspect;
uniform float sections;

//uniform sampler2D texture0;
//uniform sampler2D prevFrame;
//uniform sampler2D prevPass;

out vec4 fragColor;

vec4 red    = vec4(1,0,0,1);
vec4 green  = vec4(0,1,0,1);
vec4 blue   = vec4(0,0,1,1);
vec4 black  = vec4(0,0,0,1);
vec4 white  = vec4(1,1,1,1);


float atan2(in float y, in float x)
{
    bool s = (abs(x) > abs(y));
    return mix(PI/2.0 - atan(x,y), atan(y,x), s);
}


//////////////////// REF: https://stackoverflow.com/questions/15095909/from-rgb-to-hsv-in-opengl-glsl
vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
////////////////////


//////////////////// REF: http://www.kynd.info
float easeInQuad(float t) {
    return t * t;
}

float easeOutQuad(float t) {
    return -1.0 * t * (t - 2.0);
}

float easeInOutQuad(float t) {
    if ((t *= 2.0) < 1.0) {
        return 0.5 * t * t;
    } else {
        return -0.5 * ((t - 1.0) * (t - 3.0) - 1.0);
    }
}

float easeInCubic(float t) {
    return t * t * t;
}

float easeOutCubic(float t) {
    return (t = t - 1.0) * t * t + 1.0;
}

float easeInOutCubic(float t) {
    if ((t *= 2.0) < 1.0) {
        return 0.5 * t * t * t;
    } else {
        return 0.5 * ((t -= 2.0) * t * t + 2.0);
    }
}

float easeInExpo(float t) {
    return (t == 0.0) ? 0.0 : pow(2.0, 10.0 * (t - 1.0));
}

float easeOutExpo(float t) {
    return (t == 1.0) ? 1.0 : -pow(2.0, -10.0 * t) + 1.0;
}

float easeInOutExpo(float t) {
    if (t == 0.0 || t == 1.0) {
        return t;
    }
    if ((t *= 2.0) < 1.0) {
        return 0.5 * pow(2.0, 10.0 * (t - 1.0));
    } else {
        return 0.5 * (-pow(2.0, -10.0 * (t - 1.0)) + 2.0);
    }
}
//////////////////// 


//////////////////// REF: https://stackoverflow.com/questions/1073606/is-there-a-one-line-function-that-generates-a-triangle-wave
float saw(float radians)
{
    // returns a triangle wave of period 2PI, oscillating between values -1 and 1, starting with -1
    return (mod(radians, (2*PI)) - PI) / PI;
}

float tri(float radians)
{
    // returns a triangle wave of period 2PI, oscillating between values -1 and 1, starting with -1
    return ((abs(mod((radians + PI),(2*PI)) - PI) / PI) - 0.5) * 2;
}

float squ(float radians)
{
    // returns a square wave of period 2PI, oscillating between values -1 and 1, starting with -1
    return ((mod(radians, (2*PI))) < 2) ? -1 : 1;
}
////////////////////


////////////////////
float sin01(float radians)
{
    return 0.5 + 0.5 * sin(radians);
}

float cos01(float radians)
{
    return 0.5 + 0.5 * cos(radians);
}

float saw01(float radians)
{
    return 0.5 + 0.5 * saw(radians);
}

float tri01(float radians)
{
    return 0.5 + 0.5 * tri(radians);
}

float squ01(float radians)
{
    return 0.5 + 0.5 * squ(radians);
}
////////////////////


//////////////////// REF: https://gist.github.com/yiwenl/3f804e80d0930e34a0b33359259b556c
vec2 rotate2d(vec2 v, float a) 
{
    float s = sin(a);
    float c = cos(a);
    mat2 m = mat2(c, -s, s, c);
    return m * v;
}

mat4 rotate3dMatrix(vec3 axis, float angle) {
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;
    
    return mat4(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
                oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
                oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
                0.0,                                0.0,                                0.0,                                1.0);
}

vec3 rotate3d(vec3 v, vec3 axis, float angle) {
    mat4 m = rotate3dMatrix(axis, angle);
    return (m * vec4(v, 1.0)).xyz;
}
////////////////////


////////////////////
float clamp01(float value)
{
    return clamp(value, 0.0, 1.0); 
}

float pad01(float value, float amount)
{
    // amount: size of pad on each end
    float output1 = clamp01(value * (1 + amount*2) - amount);
    if (value < amount)
    {
        return 0;
    }
    else if (value > amount && value < 1 - amount)
    {
        return (value - amount) / (1 - amount*2);
    }
    else
    {
        return 1;
    }
}
////////////////////


////////////////////
vec2 tile(vec2 _st, float _zoom)
{
    _st *= _zoom;
    return fract(_st);
}
////////////////////


// void main(void)
// {
//     vec2 uv = vUV.st;
//     uv.x *= aspect;
//     uv = tile(uv, (int) mix(3, 10, sin01(time * 0.025)));
//     vec4 color = texture(sTD2DInputs[0], uv);
    
//     fragColor = TDOutputSwizzle(color);
// }

void main(void)
{
    vec2 uv = vUV.st;
    //uv.x *= aspect;
    //vec4 color = texture(sTD2DInputs[0], uv);
    
    //fragColor = TDOutputSwizzle(color);

    vec4 resolution = uTD2DInfos[0].res;
    vec2 pos = abs((uv - 0.5) * 2.0);//vec2(uv - 0.5 * resolution.xy) / resolution.y;

    float rad = length(pos);
    float angle = atan(pos.y, pos.x);

    float ma = mod(angle, PI2/sections);
    ma = abs(ma - PI/sections);
    
    float x = cos(ma) * rad;
    float y = sin(ma) * rad;
    vec2 xy = vec2(fract(x - time), fract(y - time));
    
    vec4 color = texture(sTD2DInputs[0], xy);
    //vec4 color = texture(sTD2DInputs[0], vec2(x - time, y - time));
    //vec4 color = texture(sTD2DInputs[0], uv);
    color.a = 1;

    fragColor = TDOutputSwizzle(color);
}
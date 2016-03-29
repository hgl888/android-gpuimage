precision mediump float;

varying vec2 vTextureCoord; //接收从顶点着色器过来的参数
varying vec2 vPosition;
uniform sampler2D sTexture1;//纹理内容数据
uniform float sGlobalTime;

vec3  iResolution = vec3(1.0, 1.0, 1.0);


const float zoom = 8.;
const float outlines = 4.;
const float edges = 5.0;
const float edgeDistance = outlines-0.5;
const float cropAngle = 3.7;//0-2*PI

#define PI 3.14159265359
#define HALF_PI 1.57079632679
#define TWO_PI 6.28318530718

float circles(vec2 uv){
    float circle = length(uv);
    circle *= 1.-step(outlines, circle);
    float angle = atan(uv.y, uv.x)+PI;
    if(angle<cropAngle)
        return  smoothstep(.05, .1, abs(fract(circle)-.5));
    return 1.0;
}

mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}


void main()                         
{
    vec2 uv = zoom * (vTextureCoord*2.-iResolution.xy)/iResolution.y;

    //bg
    vec3 color = texture2D(sTexture1, vTextureCoord).xyz;

    //circles
    for(float i=0.; i<edges; i++)
    {
        float angle = i/edges*TWO_PI-HALF_PI;
        vec2 pos = uv + vec2(cos(angle)*edgeDistance, sin(angle)*edgeDistance);
        pos *= rotate2d(-sGlobalTime-angle);
    	color = mix(vec3(0, 1, 0.8), color, circles(pos));
    }

    gl_FragColor = vec4(color,1.0);


}
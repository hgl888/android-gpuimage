precision mediump float;
varying vec2 vTextureCoord; //���մӶ�����ɫ�������Ĳ���
varying vec2 vPosition;
uniform sampler2D sTexture1;//������������
uniform float sGlobalTime;

float yVar;
vec2 s,g,m;
///////////////////////

//your funcs here if you want

///////////////////////
// source to transform
vec3 bg(vec2 uv)
{
    return texture2D(sTexture1, uv).rgg;
}

// transform effect
vec3 effect(vec2 uv, vec3 col)
{
    float grid = yVar * 10.+5.;
    float step_x = 0.0015625;
    float step_y = step_x * s.x / s.y;
    float offx = floor(uv.x  / (grid * step_x));
    float offy = floor(uv.y  / (grid * step_y));
    vec3 res = bg(vec2(offx * grid * step_x , offy * grid * step_y));
    vec2 prc = fract(uv / vec2(grid * step_x, grid * step_y));
    vec2 pw = pow(abs(prc - 0.5), vec2(2.0));
    float  rs = pow(0.45, 2.0);
    float gr = smoothstep(rs - 0.1, rs + 0.1, pw.x + pw.y);
    float y = (res.r + res.g + res.b) / 3.0;
    vec3 ra = res / y;
    float ls = 0.3;
    float lb = ceil(y / ls);
    float lf = ls * lb + 0.3;
    res = lf * res;
    col = mix(res, vec3(0.1, 0.1, 0.1), gr);
    return col;
}

///////////////////////
// screen coord system
vec2 getUV()
{
    return g / s; 
}


void main()                         
{
    s = vPosition.xy;
    g = vTextureCoord.xy;
    m = s/2.0;
    yVar = m.y/s.y;
    vec2 uv = getUV(); 
    vec3 tex = bg(uv);
    vec3 col = g.x<m.x?effect(uv,tex):tex;
    col = mix( col, vec3(0.), 1.-smoothstep( 1., 2., abs(m.x-g.x) ) );    
    gl_FragColor = vec4(col,1.);
    
		
}    
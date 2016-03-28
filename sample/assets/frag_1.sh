precision mediump float;
varying vec2 vTextureCoord; //接收从顶点着色器过来的参数
varying vec2 vPosition;
uniform sampler2D sTexture1;//纹理内容数据
uniform float sGlobalTime;

vec2 uv;
vec2 mo;
float ratio;

float metaline(vec2 p, vec2 o, float thick, vec2 l)
{
    vec2 po = 2.*p+o;
    return thick / dot(po,vec2(l.x,l.y));
}

void main()                         
{
		float speed = 0.3;
    float t0 = sGlobalTime*speed;
    float t1 = sin(t0);
    float t2 = 0.5*t1+0.5;
    float zoom=25.;
    float ratio = 1.0;
		vec2 uv = vPosition.xy;
		uv.x*=ratio;
		uv*=zoom;
 
	// cadre
    float thick=0.5;
    float inv=1.;
		float bottom = metaline(uv,vec2(0.,2.)*zoom, thick, vec2(0.0,1.*inv));
		float top = metaline(uv,vec2(0.,-2.)*zoom, thick, vec2(0.0,-1.*inv));
		float left = metaline(uv,vec2(2.*ratio,0.)*zoom, 0.5, vec2(1.*inv,0.0));
		float right = metaline(uv,vec2(-2.*ratio,0.)*zoom, 0.5, vec2(-1.*inv,0.0));
		float rect=bottom+top+left+right;
    
    // uv / mo
    vec2 uvo = uv;//-mo;
    float phase=1.1;
    float tho = length(uvo)*phase+t1;
    float thop = t0*20.;
    
    // map spiral
   	uvo+=vec2(tho*cos(tho-1.25*thop),tho*sin(tho-1.15*thop));
    
    // metaball
    float mbr = 8.;
    float mb = mbr / dot(uvo,uvo);

	//display
    float d0 = mb+rect;
    
    float d = smoothstep(d0-2.,d0+1.2,1.);
    
		float r = mix(1./d, d, 1.);
    float g = mix(1./d, d, 3.);
    float b = mix(1./d, d, 5.);
    vec3 c = vec3(r,g,b);
    
    gl_FragColor.rgb = c;
    gl_FragColor.a = 1.0;
		
}    
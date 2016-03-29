precision mediump float;

varying vec2 vTextureCoord; //接收从顶点着色器过来的参数
varying vec2 vPosition;
uniform sampler2D sTexture1;//纹理内容数据
uniform float sGlobalTime;

vec3  iResolution = vec3(1.0, 0.6, 1.0);

float noise(vec3 p) //Thx to Las^Mercury
{
	vec3 i = floor(p);
	vec4 a = dot(i, vec3(1., 57., 21.)) + vec4(0., 57., 21., 78.);
	vec3 f = cos((p-i)*acos(-1.))*(-.5)+.5;
	a = mix(sin(cos(a)*a),sin(cos(1.+a)*(1.+a)), f.x);
	a.xy = mix(a.xz, a.yw, f.y);
	return mix(a.x, a.y, f.z);
}

float sphere(vec3 p, vec4 spr)
{
	return length(spr.xyz-p) - spr.w;
}

float flame(vec3 p)
{
	float d = sphere(p*vec3(1.,.5,1.), vec4(.0,-1.,.0,1.));
	return d + (noise(p+vec3(.0,sGlobalTime*2.,.0)) + noise(p*3.)*.5)*.25*(p.y) ;
}

float scene(vec3 p)
{
	return min(100.-length(p) , abs(flame(p)) );
}

vec4 raymarch(vec3 org, vec3 dir)
{
	float d = 0.0, glow = 0.0, eps = 0.2;
	vec3  p = org;
	bool glowed = false;

	for(int i=0; i<16; i++)
	{
		d = scene(p) + eps;
		p += d * dir;
		if( d>eps )
		{
			if(flame(p) < .0)
				glowed=true;
			if(glowed)
      			glow = float(i)/16.;
		}
	}
	return vec4(p,glow);
}


void main()                         
{
	vec2 v = -1.0 + 2.0 * vPosition.xy / iResolution.xy;
	v.x *= iResolution.x/iResolution.y;

	vec3 org = vec3(0.0, -2.0, 4.0);
	vec3 dir = normalize(vec3(v.x*1.6, -v.y, -1.5));

	vec4 p = raymarch(org, dir);
	float glow = p.w;
	float powval = pow( glow * 2.0, 4.0);

	vec4 col = mix(vec4(1.,.5,.1,1.), vec4(0.1,0.5,1.0,1.0), p.y*.02+.4);
	//vec4 col = mix(vec4(1.,.5,.1,1.), vec4(0.1,0.5,1.0,1.0), .02+.4);
	//vec4 col = vec4( 0.0);
	vec4 bcol = texture2D(sTexture1, vTextureCoord);
	gl_FragColor = mix(bcol, col, powval);
	//gl_FragColor = col;

}    
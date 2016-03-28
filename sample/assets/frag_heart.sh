precision mediump float;
varying vec2 vTextureCoord; //接收从顶点着色器过来的参数
varying vec2 vPosition;
uniform sampler2D sTexture1;//纹理内容数据
uniform float sGlobalTime;

float smoothstepmy( float x, float y, float a )
{
	if( a < x )
		return 0.0;
	else if( a > y )
		return 1.0;
	else
	{
		float m = a - x;
		float n = y - x;
		return m/n;
	}
}


void main()                         
{           
		vec4 layer1 = texture2D(sTexture1, vTextureCoord);
		//float d = length( vPosition) - 0.2;
		//float t = smoothstepmy( 0.1, 0.11, d );
		//vec4 layer2 = vec4( 1.0, 1.0, 0.5, 1.0 - t );
		//gl_FragColor = mix( layer1, layer2, layer2.a );

   //给此片元从纹理中采样出颜色值            
   //gl_FragColor = texture2D(sTexture1, vTextureCoord);
   
   	vec2 p = vPosition;
		p.y -= 0.25;

    // background color
    //vec3 bcol = vec3(1.0,0.8,0.7-0.07*p.y)*(1.0-0.25*length(p));
    vec3 bcol = layer1.xyz;
    // animate
    float tt = mod(sGlobalTime, 1.5)/1.5;
    float ss = pow(tt, 0.2)*0.5 + 0.5;
    ss = 1.0 + ss*0.5*sin(tt*6.2831*3.0 + p.y*0.5)*exp(-tt*4.0);
    p *= vec2(0.5,1.5) + ss*vec2(0.5,-0.5);
   
    // shape
    float a = atan(p.x,p.y)/3.141593;
    float r = length(p);
    float h = abs(a);
    float d = (13.0*h - 22.0*h*h + 10.0*h*h*h)/(6.0-5.0*h);

		// color
		float s = 1.0-0.5*clamp(r/d,0.0,1.0);
		s = 0.75 + 0.75*p.x;
		s *= 1.0-0.25*r;
		s = 0.5 + 0.6*s;
		s *= 0.5+0.5*pow( 1.0-clamp(r/d, 0.0, 1.0 ), 0.1 );
		vec3 hcol = vec3(1.0,0.5*r,0.3)*s;
	
    vec3 col = mix( bcol, hcol, smoothstepmy( -0.01, 0.01, d-r) );

    gl_FragColor = vec4(col,1.0);
    
}              
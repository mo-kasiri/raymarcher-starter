#define PI 3.1415926538
#define MAX_DIST 100.
#define MAX_STEPS 1000
#define SURFACE_DIST 0.01

uniform vec2 iResolution;
uniform float iTime;


varying vec2 vUv;



float GetDist(vec3 p){
    vec4 sphere = vec4(0.0, iTime +  1.0, iTime + 6.0, 1.0);
    float sphereDist = length(p - sphere.xyz) - sphere.w;
    float planeDist = p.y;
    float dis = min(sphereDist, planeDist);
    return dis;
}

float RayMarch(vec3 ro, vec3 rd){
    float d0 = 0.0;
    for(int i=0; i<MAX_STEPS; i++){
        vec3 p = ro + d0 * rd;
        float ds = GetDist(p);
        d0 += ds;
        //if (ds < SURFACE_DIST || d0 > MAX_DIST) break;
        if (ds < SURFACE_DIST)  return .0;
        else if (ds > MAX_DIST) return 1.;
    }
    //return d0;
}

void main()
{
    vec2 p = (2. * gl_FragCoord.xy - iResolution.xy)/ iResolution.y;
    //vec2 p = vUv;

    vec3 col = vec3(0);
    vec3 ro = vec3( 0.0, 1., 0.0);
    vec3 rd = normalize(vec3(p.x, p.y , 1.0));

    float d = RayMarch(ro,rd);
    //d/= 6.;
    col = vec3(d);
    gl_FragColor = vec4(col,1.0);
}




/*//float strength = fract(10.0 * vUv.y);
//float strength = ceil(sin(60.0 * vUv.y));
//float strength  = floor(mod(vUv.y * 20.0 , 2.0));
//    float strengthV = mod(vUv.x * 10.0, 1.0);
//    strengthV = step(0.8, strengthV);
//
//    float strengthH = mod(vUv.y * 10.0, 1.0);
//    strengthH = step(0.8, strengthH);

//float intersection = step(1.1, strengthH + strengthV);
//float intersection = strengthV + strengthH;
//    if(strengthH == strengthV){
//        intersection = strengthH;
//    }
//float strength = vUv.x;

//    vec2 uv = vUv;
//    vec2 uv2 = vUv;
//    uv -= 0.5;
//    uv2 -= 0.5;
//
//
//    uv.x = uv.x * cos(PI/ 4.0) - uv.y * sin(PI/4.0);
//    uv.y = uv.x * sin(PI/4.0) + uv.y * cos(PI/4.0);
//
//    uv2.x = uv2.x * cos(-PI/ 4.0) - uv2.y * sin(-PI/4.0);
//    uv2.y = uv2.x * sin(-PI/4.0) + uv2.y * cos(-PI/4.0);
//
//    uv.y  *= 0.5;
//    uv2.y *= 0.5;
//
//    float strength = 0.015 / length(uv) - 0.1;
//    strength += 0.015 / length(uv2) - 0.1;*/

//    vec2 uv = vUv;
//    uv -= 0.5;
//    float strength = floor(length(uv) * 4.0);

//gl_FragColor = vec4(strength, strength, strength, 1.0);
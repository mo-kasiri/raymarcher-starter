#define PI 3.1415926538
#define MAX_DIST 100.
#define MAX_STEPS 500
#define SURFACE_DIST 0.01

uniform vec2 iResolution;
uniform float iTime;
uniform vec2 iMouse;

varying vec2 vUv;

float GetDist(vec3 p){
    vec4 sphere = vec4(0.0, 1.0, 6.0, 1.0);
    float sphereDist = length(p - sphere.xyz) - sphere.w;
    float pydist = p.y;
    float dis = min(sphereDist, pydist);
    return dis;
}

float RayMarch(vec3 ro, vec3 rd){
    float d0 = 0.0;
    for(int i=0; i<MAX_STEPS; i++){
        vec3 p = ro + d0 * rd; // blue points on the circles
        float ds = GetDist(p);
        d0 += ds;
        if (ds < SURFACE_DIST || d0 > MAX_DIST) break;
    }
    return d0; // Returns the distance of the camera origin (based on the specific pixel) to the sphere of plane
}

vec3 GetNormal(vec3 p)
{
    float d = GetDist(p);
    vec2 e = vec2(0.01,0.0);
    vec3 dists = vec3(GetDist(p- e.xyy), GetDist(p - e.yxy), GetDist(p - e.yyx)); //
    vec3 n = d - dists;
    return normalize(n);
}

float GetLight (vec3 p){
    vec4 sphere = vec4(0.0, 1.0, 6.0, 1.0);
    vec3 lightPos = vec3(0., 5., 6.);
    lightPos.xz += vec2(sin(iTime), cos(iTime)*2.);
    //lightPos.y += 2. * iMouse.y;
    //lightPos.x += 2. * iMouse.x;
    vec3 lightDirection = normalize(lightPos - p);
    vec3 n = GetNormal(p);
    //float dif = dot(n,l);
    float dif = clamp(dot(n,lightDirection), 0., 1.);

    float d = RayMarch(p + n * SURFACE_DIST * 2., lightDirection);
    if(d<length(lightPos - p)) dif = dif * 0.5;
    return dif;
}

void main()
{
    vec2 uv = (2. * gl_FragCoord.xy - iResolution.xy)/ iResolution.y;
    //vec2 p = vUv;

    vec3 col = vec3(0);
    vec3 ro = vec3(0.0, 1., 0.0);
    vec3 rd = normalize(vec3(uv.x, uv.y , 1.0));

    float d = RayMarch(ro,rd); // The distanse from the origin (based on pixel direction) to the collision point

    vec3 p = ro + rd * d;   // The coordinate of the collision point based on the ray casted from camera origin (based on pixel direction)
                            // another word: if you cast a ray from each pixel it will collid to a point,
                            // the coordination of that specific point is 'vec3 p = ro + rd * d' which d was calculated by raymarching


    float dif = GetLight(p);
    col = vec3(dif);

    //vec3 normcol = normalize(vec3(col));
    //col = GetNormal(p);
    gl_FragColor = vec4(col,1.0);
}

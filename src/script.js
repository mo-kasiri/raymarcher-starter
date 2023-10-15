import './style.css'
import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
import * as dat from 'lil-gui'
import testVertexShader from './shaders/test/vertex.glsl'
import testFragmentShader from './shaders/test/fragment.glsl'



let container, camera, scene, uniforms, renderer;

const sizes = {
    width: window.innerWidth,
    height: window.innerHeight
}
const clock = new THREE.Clock();


init();
animate();


function init(){
    container = document.getElementById('container');
    const canvas = document.querySelector('canvas.webgl');
    camera = new THREE.Camera();
    camera.position.z = 1;
    scene = new THREE.Scene();

    const axisHelper = new THREE.AxesHelper(2);


    /**
     * Renderer
     */
    renderer = new THREE.WebGLRenderer({
        canvas: canvas,
        antialias: true
    })
    renderer.setSize(sizes.width, sizes.height)
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))

    let geometry = new THREE.PlaneGeometry(2,2);

    uniforms = {
        iTime: {value: 0.},
        iResolution: {value: new THREE.Vector2(renderer.domElement.width,renderer.domElement.height)},
        iMouse: {value: new THREE.Vector2()}
    }

    let material = new THREE.ShaderMaterial({
        uniforms: uniforms,
        vertexShader: testVertexShader,
        fragmentShader: testFragmentShader,
        side: {value: THREE.DoubleSide}
    });

    let mesh = new THREE.Mesh(geometry, material);
    scene.add(mesh, axisHelper);

    document.onmousemove = function (e){
        uniforms.iMouse.value.x = e.pageX / sizes.width;
        uniforms.iMouse.value.y = e.pageY / sizes.height;
        //console.log(e.pageY / sizes.height);
    }
}


window.addEventListener('resize', () =>
{
    // Update sizes
    sizes.width = window.innerWidth
    sizes.height = window.innerHeight

    uniforms.iResolution.value.x = renderer.domElement.width;
    uniforms.iResolution.value.y = renderer.domElement.height;

    console.log(renderer.domElement)

    // Update renderer
    renderer.setSize(sizes.width, sizes.height)
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
})


function animate(delta_ms) {

    const elapsedTime = clock.getElapsedTime();

    uniforms.iTime.value = elapsedTime;

    /* Render */
    renderer.render(scene, camera)
    window.requestAnimationFrame(animate);
    // render(delta_ms);
}





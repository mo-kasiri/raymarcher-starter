import './style.css'
import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
import * as dat from 'lil-gui'
import testVertexShader from './shaders/test/vertex.glsl'
import testFragmentShader from './shaders/test/fragment.glsl'



/**
 * Base
 */
// Debug
const gui = new dat.GUI();
const axisHelper = new THREE.AxisHelper(2);


// Canvas
const canvas = document.querySelector('canvas.webgl');

// Scene
const scene = new THREE.Scene();

/**
 * Test mesh
 */
// Geometry
const geometry = new THREE.PlaneGeometry(1, 1, 32, 32)
console.log(geometry);

// Shader Material no rawShaderMaterial
const material = new THREE.ShaderMaterial({
    vertexShader: testVertexShader,
    fragmentShader: testFragmentShader,
    side: THREE.DoubleSide,
    uniforms:
        {
            iResolution: {value: new THREE.Vector2(1, 1)},
            iTime: {value:0}
        }
})

// Mesh
const mesh = new THREE.Mesh(geometry, material);
mesh.position.set(0,0,0);
scene.add(mesh, axisHelper);

/**
 * Sizes
 */
const sizes = {
    width: window.innerWidth,
    height: window.innerHeight
}

window.addEventListener('resize', () =>
{
    // Update sizes
    sizes.width = window.innerWidth
    sizes.height = window.innerHeight

    // Update camera
    camera.aspect = sizes.width / sizes.height
    camera.updateProjectionMatrix()

    // Update renderer
    renderer.setSize(sizes.width, sizes.height)
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
})

/**
 * Camera
 */
// Base camera
const camera = new THREE.PerspectiveCamera(45, sizes.width / sizes.height, 0.01, 100)
camera.position.set(0, 0, 1);
const cameraDirection = new THREE.Vector3(1,1,1);
//camera.getWorldDirection(cameraDirection);

//camera.lookAt(1.,1.,1.);
scene.add(camera);

// Controls
const controls = new OrbitControls(camera, canvas)
controls.enableDamping = true

//gui.add(camera., 'x').min(0).max(20).step(0.01).name('frequencyX');
//gui.add(material.current.uniforms.uFrequency.value, 'y').min(0).max(20).step(0.01).name('frequencyY');


/**
 * Renderer
 */
const renderer = new THREE.WebGLRenderer({
    canvas: canvas,
    antialias: true
})
renderer.setSize(sizes.width, sizes.height)
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))

/**
 * Animate
 */

const clock = new THREE.Clock();
const tick = () =>
{
    const elapsedTime = clock.getElapsedTime();

    material.uniforms.iTime.value = elapsedTime;

    // Update controls
    controls.update()
    //camera.position.set(0, 0, 1);
    //camera.lookAt(0,0,1);

    // Render
    renderer.render(scene, camera)

    // Call tick again on the next frame
    window.requestAnimationFrame(tick)
}

tick()
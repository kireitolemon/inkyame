<script setup>
import { defineComponent, onMounted, ref } from 'vue';
import * as faceapi from 'face-api.js';
import p5 from 'p5';

import faceImage from './assets/images/face.png'
import eyelidImage from './assets/images/eyelid.png'
import eyeballImage from './assets/images/eyeball.png'

const p5Canvas = ref(null);  // Define the ref properly here

let faceX = 0;
let faceY = 0;

const CAMERA_WIDTH = 352;
const CAMERA_HEIGHT = 198;

const sketch = (p) => {
  let face, eyelid, eyeball;
  let mabatakiFlag = 0;
  let isEyelidOpen = true;
  let mabatakiCycle = 5000;
  let eyeBallX = 0;
  let eyeBallY = 0;

  const WINDOW_WIDTH = p.min(p.windowWidth, 800);
  const WINDOW_HEIGHT = p.min(p.windowHeight, 450);

  p.setup = () => {
    p.createCanvas(WINDOW_WIDTH, WINDOW_HEIGHT);
    p.noStroke();
    p.frameRate(15);
    
    // Load images
    // face = p.loadImage(faceImage);
    face = p.loadImage(faceImage, img => {
      img.resize(WINDOW_WIDTH, WINDOW_HEIGHT);
    });
    // eyelid = p.loadImage(eyelidImage);
    eyelid = p.loadImage(eyelidImage, img => {
      img.resize(WINDOW_WIDTH, WINDOW_HEIGHT);
    });
    // eyeball = p.loadImage(eyeballImage);
    eyeball = p.loadImage(eyeballImage, img => {
      img.resize(WINDOW_WIDTH, WINDOW_HEIGHT);
    }); 
  };

  p.draw = () => {
    // Manage blink cycle
    if (p.millis() - mabatakiFlag > mabatakiCycle) {
      isEyelidOpen = false;
      mabatakiFlag = p.millis();
    }
    if (p.millis() - mabatakiFlag > 120 && !isEyelidOpen) {
      isEyelidOpen = true;
      mabatakiCycle = p.floor(p.random(3500, 6000));
    }

    // Display the eyes
    if (isEyelidOpen) {
      p.background("#fff5e3");
      eyeballPos();
      p.fill(255);
      p.rect(0, 0, p.width, p.height - 30);
      p.image(eyeball, eyeBallX, eyeBallY);
      p.image(face, 0, 0);
      p.image(eyelid, 0, -230);
    } else {
      p.background("#fff5e3");
      p.image(eyelid, 0, -50);
    }
  };

  // Function to set eyeball position
  function eyeballPos() {
    eyeBallX = p.map(faceX, 0, CAMERA_WIDTH, 70, -70);
    eyeBallY = p.map(faceY, 0, CAMERA_HEIGHT, -45, 45);
  }
};

onMounted(async () => {
  if (p5Canvas.value) {
    new p5(sketch, p5Canvas.value);
  }

  // WebGPUが使えるかチェック
  const canUseWebGPU = await faceapi.tf.setBackend("webgpu").then(() => true).catch(() => false);

  if (!canUseWebGPU) {
    console.warn("WebGPU not available, falling back to WebGL");
    await faceapi.tf.setBackend("webgl");
  }

  await faceapi.tf.enableProdMode();
  await faceapi.tf.ENV.set("DEBUG", false);
  await faceapi.tf.ready();

  // モデルのロード
  Promise.all([
    faceapi.nets.ssdMobilenetv1.loadFromUri('/weights'),
  ]).then(startVideo);

  function startVideo() {
    const video = document.getElementById('video');
    navigator.mediaDevices
      .getUserMedia({
        video: { width: CAMERA_WIDTH, height: CAMERA_HEIGHT, facingMode: "user" }
      })
      .then((stream) => {
        video.srcObject = stream;
        video.onplaying = () => {
          detectFace(video);
        };
      })
      .catch((err) => {
        console.error('Error accessing webcam: ', err);
      });
  }

  async function detectFace(video) {
    console.log('Face detection started');
    setInterval(async () => {
      const detection = await faceapi.detectSingleFace(video);
      if (detection) {
        const { x, y } = detection._box;
        faceX = Math.floor(x);
        faceY = Math.floor(y);
        console.log(`Face detected at x: ${faceX}, y: ${faceY}`);
      }
    }, 100);
  }
});
</script>

<template>
  <div class="app">
    <div ref="p5Canvas"></div>
    <video id="video" autoplay muted playsinline></video>
  </div>
</template>

<style scoped>
.app {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100vw;
  height: 100vh;
}

video {
  opacity: 0;
  position: absolute;
  top: 0;
  left: 0;
}
</style>

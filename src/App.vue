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

const sketch = (p) => {
  let face, eyelid, eyeball;
  let mabatakiFlag = 0;
  let isEyelidOpen = true;
  let mabatakiCycle = 5000;
  let eyeBallX = 0;
  let eyeBallY = 0;

  p.setup = () => {
    p.createCanvas(p.windowWidth, p.windowHeight);
    p.noStroke();
    
    // Load images
    face = p.loadImage(faceImage);
    eyelid = p.loadImage(eyelidImage);
    eyeball = p.loadImage(eyeballImage);
  };

  p.draw = () => {
    // Manage blink cycle
    if (p.millis() - mabatakiFlag > mabatakiCycle) {
      isEyelidOpen = false;
      mabatakiFlag = p.millis();
    }
    if (p.millis() - mabatakiFlag > 120 && !isEyelidOpen) {
      isEyelidOpen = true;
      mabatakiCycle = p.random(3500, 6000);
    }

    // Display the eyes
    if (isEyelidOpen) {
      p.background("#ffffff");
      eyeballPos();
      p.image(eyeball, eyeBallX, eyeBallY, p.width, p.height);
      p.image(face, 0, 0, p.width, p.height);
      p.image(eyelid, 0, -210, p.width, p.height);
    } else {
      p.background("#fff5e3");
      p.image(eyelid, 0, -50, p.width, p.height);
    }
  };

  // Function to set eyeball position
  function eyeballPos() {
    eyeBallX = p.map(faceX, 0, 550, 50, -50);
    eyeBallY = p.map(faceY, 0, 300, -30, 30);
  }
};

onMounted(() => {
  if (p5Canvas.value) {
    new p5(sketch, p5Canvas.value);  // Attach p5 canvas to the div
  }
  
  // モデルのロード
  Promise.all([
    faceapi.nets.ssdMobilenetv1.loadFromUri('/weights'),
    faceapi.nets.faceLandmark68Net.loadFromUri('/weights'),
    faceapi.nets.faceRecognitionNet.loadFromUri('/weights')
  ]).then(startVideo);

  // カメラストリームの取得
  function startVideo() {
  const video = document.getElementById('video');
  navigator.mediaDevices
    .getUserMedia({
      video: { facingMode: "user" }  // 内カメラを使用
    })
    .then((stream) => {
      video.srcObject = stream;

      // videoが再生されるのを待ってから顔認識を開始
      video.onplaying = () => {
        detectFace(video);
      };
    })
    .catch((err) => {
      console.error('Error accessing webcam: ', err);
    });
}


  // 顔認識を実行
  async function detectFace(video) {
    console.log('Face detection started');
    // 顔認識のループ
    setInterval(async () => {
      const detections = await faceapi.detectSingleFace(video)
        .withFaceLandmarks()
        .withFaceDescriptor();
      // faceapi.matchDimensions(canvas, video);

      if (detections) {
        const box = detections.detection._box;
        const x = box.x;
        const y = box.y;
        if(x && y) {
          console.log(`Face detected at x: ${x}, y: ${y}`);
          faceX = x;
          faceY = y;
        }
      }
    }, 10);
  }
});
</script>

<template>
  <div>
    <div ref="p5Canvas"></div>
    <video id="video" autoplay muted></video>
  </div>
</template>

<style scoped>
div {
  width: 100%;
  height: 100%;
}

video {
  visibility: hidden;
  position: absolute;
  top: 0;
  left: 0;
}
</style>

<script setup>
import { onMounted } from 'vue';
import * as faceapi from 'face-api.js';

// モデルのロード
onMounted(() => {
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
        video: true
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
        }
      }
    }, 50);
  }
});
</script>

<template>
  <div>
    <video id="video" width="720" height="560" autoplay muted></video>
  </div>
</template>

<style scoped>
#video {
  visibility: hidden;
}
</style>

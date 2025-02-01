<script setup>
import { defineComponent, onMounted, ref } from 'vue';
import * as faceapi from 'face-api.js';
import p5 from 'p5';
faceapi.tf.setBackend('webgl');

// 画像のインポート
import faceImage from './assets/images/face.png'
import eyelidImage from './assets/images/eyelid.png'
import eyeballImage from './assets/images/eyeball.png'

// p5のキャンバスを格納するref
const p5Canvas = ref(null);

let faceX = 0; // 顔のx座標
let faceY = 0; // 顔のy座標

// p5.jsのスケッチ関数
const sketch = (p) => {
  let face, eyelid, eyeball;
  let mabatakiFlag = 0;      // まばたきのタイミング管理用フラグ
  let isEyelidOpen = true;    // まぶたの状態（開いているかどうか）
  let mabatakiCycle = 5000;   // まばたきの周期（ミリ秒単位）
  let eyeBallX = 0;           // 眼球のx座標
  let eyeBallY = 0;           // 眼球のy座標

  // オフスクリーンバッファ
  let openBuffer, closedBuffer;

  // 初期設定
  p.setup = () => {
    p.createCanvas(p.windowWidth, p.windowHeight);
    p.frameRate(30);
    p.noStroke();
    
    // 画像の読み込み
    face = p.loadImage(faceImage);
    eyelid = p.loadImage(eyelidImage);
    eyeball = p.loadImage(eyeballImage);

    // バッファ生成（画像読み込み完了後に生成する前提）
    openBuffer = p.createGraphics(p.width, p.height);
    openBuffer.noStroke();
    openBuffer.background("#ffffff");
    openBuffer.image(face, 0, 0, p.width, p.height);
    openBuffer.image(eyelid, 0, -210, p.width, p.height);
    
    closedBuffer = p.createGraphics(p.width, p.height);
    closedBuffer.noStroke();
    closedBuffer.background("#fff5e3");
    closedBuffer.image(eyelid, 0, -50, p.width, p.height);
  };

  // 描画ループ
  p.draw = () => {
    // まばたきの管理
    if (p.millis() - mabatakiFlag > mabatakiCycle) {
      isEyelidOpen = false;
      mabatakiFlag = p.millis();
    }
    if (p.millis() - mabatakiFlag > 120 && !isEyelidOpen) {
      isEyelidOpen = true;
      mabatakiCycle = p.random(3500, 6000);
    }

    // まぶたが開いている場合の描画
    if (isEyelidOpen) {
      p.background("#ffffff");
      eyeballPos();  // 眼球の位置を更新
      p.image(eyeball, eyeBallX, eyeBallY, p.width, p.height);
      p.image(openBuffer, 0, 0);
    } else {
      // まばたき中の描画
      p.image(closedBuffer, 0, 0);
    }
  };

  // 眼球の位置を計算する関数
  function eyeballPos() {
    // 顔の位置に応じて眼球位置をマッピング
    eyeBallX = p.map(faceX, 0, 550, 50, -50);
    eyeBallY = p.map(faceY, 0, 300, -30, 30);
  }
};

// Vueコンポーネントがマウントされた後の処理
onMounted(() => {
  // p5のキャンバスをdivにアタッチ
  if (p5Canvas.value) {
    new p5(sketch, p5Canvas.value);
  }
  
  // FaceAPIのモデルをロード
  Promise.all([
    faceapi.nets.ssdMobilenetv1.loadFromUri('/weights'),
    faceapi.nets.faceLandmark68Net.loadFromUri('/weights'),
    faceapi.nets.faceRecognitionNet.loadFromUri('/weights')
  ]).then(startVideo);

  // カメラストリームを開始する関数
  function startVideo() {
    const video = document.getElementById('video');
    navigator.mediaDevices
      .getUserMedia({
        video: { facingMode: "user" }  // フロントカメラを使用
      })
      .then((stream) => {
        video.srcObject = stream;

        // videoの再生開始を待ってから顔認識を開始
        video.onplaying = () => {
          detectFace(video);
        };
      })
      .catch((err) => {
        console.error('ウェブカメラへのアクセスエラー: ', err);
      });
  }

  // 顔認識を実行する関数
  async function detectFace(video) {
    console.log('顔認識開始');
    // 顔認識処理のループ
    setInterval(async () => {
      const detections = await faceapi.detectSingleFace(video)
        .withFaceLandmarks()

      if (detections) {
        const box = detections.detection._box;
        const x = box.x;
        const y = box.y;
        if(x && y) {
          console.log(`顔検出: x: ${x}, y: ${y}`);
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
    <!-- p5.jsのキャンバスを描画するdiv -->
    <div ref="p5Canvas"></div>
    <!-- 顔認識用のvideo要素（表示はしない） -->
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

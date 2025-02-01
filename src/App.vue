<script setup>
import p5 from "p5";
import faceImage from './assets/images/face.png'
import eyelidImage from './assets/images/eyelid.png'
import eyeballImage from './assets/images/eyeball.png'

const sketch = (p) => {
  let face, eyelid, eyeball;
  let mabatakiFlag = 0;
  let isEyelidOpen = true;
  let mabatakiCycle = 5000;
  let eyeBallX = 0;
  let eyeBallY = 0;
  p.setup = () => {
    face = p.loadImage(faceImage);
    eyelid = p.loadImage(eyelidImage);
    eyeball = p.loadImage(eyeballImage);
    p.createCanvas(p.windowWidth, p.windowHeight);
  };
  p.draw = () => {
    //瞬きの管理
    if (p.millis() - mabatakiFlag > mabatakiCycle) {
      isEyelidOpen = false;
      mabatakiFlag = p.millis()

    }
    if (p.millis() - mabatakiFlag > 120 && !isEyelidOpen) {
      isEyelidOpen = true;
      mabatakiCycle = p.random(3500, 6000);
    }
    //眼の表示関連
    if (isEyelidOpen) {
      p.background("#ffffff");
      eyeballPos();
      p.image(eyeball, 0, -20, p.width, p.height);
      p.image(face, 0, 0, p.width, p.height);
      p.image(eyelid, 0, -210, p.width, p.height);
    } else {//目が閉じている場合
      p.background("#fff5e3");
      p.image(eyelid, 0, -50, p.width, p.height);
    }
  };
  function eyeballPos() {
  }
}

new p5(sketch);
</script>

<template>
  <div ref="camvas">

  </div>
</template>

<style scoped>
.logo {
  height: 6em;
  padding: 1.5em;
  will-change: filter;
  transition: filter 300ms;
}

.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
}

.logo.vue:hover {
  filter: drop-shadow(0 0 2em #42b883aa);
}
</style>

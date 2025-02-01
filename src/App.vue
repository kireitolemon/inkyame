<script setup>
import { defineComponent, onMounted, ref } from 'vue';
import p5 from 'p5';

import faceImage from './assets/images/face.png'
import eyelidImage from './assets/images/eyelid.png'
import eyeballImage from './assets/images/eyeball.png'

const p5Canvas = ref(null);  // Define the ref properly here

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
    eyeBallX = p.mouseX - p.width / 2;
    eyeBallY = p.mouseY - p.height / 2;
  }
};

onMounted(() => {
  if (p5Canvas.value) {
    new p5(sketch, p5Canvas.value);  // Attach p5 canvas to the div
  }
});
</script>

<template>
  <div ref="p5Canvas"></div>
</template>

<style scoped>
div {
  width: 100%;
  height: 100%;
}
</style>

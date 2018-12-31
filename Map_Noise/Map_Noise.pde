float x_seed = 0.0;
float y_seed = 5.0;
float s_seed = 3.0;
float c1_seed = 1.0;
float c2_seed = 2.0;
float c3_seed = 3.0;
float c4_seed = 4.0;
int maxSize = 100;


float value = 57,
oldLow = 20,
oldHigh = 200,
newLow = 10,
newHigh = 255;

void setup() {
  size(1200, 800);
  noStroke();
}

void draw() {
  background(0);
  x_seed += .01;
  y_seed += .01;
  s_seed += .03;
  c1_seed += .01;
  c2_seed += .01;
  c3_seed += .01;
  c4_seed += .01;
  float x = noise(x_seed) * width;
  float y = noise(y_seed) * height;
  float s = noise(s_seed) * maxSize;
  float c1 = noise(c1_seed) * 170;
  float c2 = noise(c2_seed) * 255;
  float c3 = noise(c3_seed) * 155;
  float c4 = noise(c4_seed) * 200;
  fill(c1, c2, c3, c4);
  ellipse(x, y, s, s);
  
  
  float m = map(value, oldLow, oldHigh, newLow, newHigh);
  println("m = "+ m);
  
  float n = newLow + ((value - oldLow)/(oldHigh - oldLow))*(newHigh - newLow);
  println("n = "+ n);
}

float r_seed = 0.0;
float theta = 0;
float r_temp = 0.0;
float r;

int size_seed = 1;
float c1_seed = 1.0;
float c2_seed = 2.0;
float c3_seed = 3.0;
float c4_seed = 4.0;


void setup() {
  size(1200, 800);
  background(255);
  smooth();
  noStroke();
  fill(0);
}
void draw() {
  float r_noise = noise(r_seed) * 20;
  r_temp += .04;
  r = r_temp + r_noise;

  float x = r * cos(theta);
  float y = r * sin(theta);

  size_seed += 1;
  float size = noise(size_seed) * 30;


  c1_seed += .01;
  c2_seed += .01;
  c3_seed += .01;
  c4_seed += .01;
  float c1 = noise(c1_seed) * 255;
  float c2 = noise(c2_seed) * 255;
  float c3 = noise(c3_seed) * 255;
  float c4 = noise(c4_seed) * 50;
  
  fill(c1, c2, c3, c4);
  ellipse(x + width*1/3, y + height*1/3, size, 1);
  ellipse(x + width*2/3, y + height*1/3, size, 1);
  ellipse(x + width*1/3, y + height*2/3, size, 1);
  ellipse(x + width*2/3, y + height*2/3, size, 1);
  ellipse(x + width/2, y + height/2, 1, size);

  theta += 0.03;
  r_seed += .1;
}

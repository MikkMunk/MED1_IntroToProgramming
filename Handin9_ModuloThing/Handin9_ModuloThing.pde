int num = 50;
Particle[] particle = new Particle[num];
int[] x = new int[num];
int[] y = new int[num];
int indexPosition = 0;

void setup() {
  size(1200, 800);
  noCursor();
  noStroke();
  textAlign(CENTER, CENTER);
}

void draw() {
  background(0);
  x[indexPosition] = mouseX;
  y[indexPosition] = mouseY;
  indexPosition = (indexPosition + 1) % num;
  for (int i = 0; i < num; i++) {
    int pos = (indexPosition + i) % num;
    particle[pos] = new Particle(x[pos], y[pos], pos);
    particle[pos].update();
  }
  
  /*background(0);
  // Shift the values to the right
  for (int i = num-1; i > 0; i--) {
    x[i] = x[i-1];
    y[i] = y[i-1];
  }
  x[0] = mouseX;
  y[0] = mouseY;
  for (int i = 0; i < num; i++) {
    particle[i] = new Particle(x[i], y[i], i);
    particle[i].update();
  }*/
}

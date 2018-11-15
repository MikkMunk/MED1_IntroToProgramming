int num = 50;
Particle[] particle = new Particle[num];
int[] x = new int[num];
int[] y = new int[num];
int indexPosition = 0;

void setup() {
  size(1200, 800);
  noCursor();
  noStroke();
}

void draw() {
 background(0);
  x[indexPosition] = mouseX;
  y[indexPosition] = mouseY;
  indexPosition = (indexPosition + 1) % num;
  for (int i = 0; i < num; i++) {
    int pos = (indexPosition + i) % num;
    particle[pos] = new Particle(x[pos], y[pos]);
    particle[pos].update();
  }
}

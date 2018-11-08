class Particle {
  float x, 
    y, 
    d;

  int number;

  Particle(float x_temp, float y_temp, float d_temp, int number_temp) {
    x = x_temp;
    y = y_temp;
    d = d_temp;
    number = number_temp;
  }

  void update() {
    fill(255, 102);
    ellipse(x, y, d, d);
    fill(0);
    text(number, x, y);
  }
}

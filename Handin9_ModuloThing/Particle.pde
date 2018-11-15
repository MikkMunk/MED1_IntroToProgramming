class Particle {

  PVector pos;
  
  int petalAmount = 5, col1 = (int)random(255), col2 = (int)random(255), col3 = (int)random(255), alpha = 150;
  
  float x, 
  y, 
  size = 20;

  Particle(float x_temp, float y_temp) {
    x = x_temp;
    y = y_temp;
  }

  void update() {
    fill(col1, col2, col3, 100);
    noStroke();
    for (float i = 0; i < PI*2; i += 2 * PI/petalAmount) {
      float ballX = x + size*cos(i);
      float ballY = y + size*sin(i);
      ellipse(ballX, ballY, size, size);
    }
    ellipse(x, y, size, size);
  }
}

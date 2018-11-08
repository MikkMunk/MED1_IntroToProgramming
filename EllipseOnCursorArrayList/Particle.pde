class Particle {

  PVector pos;
  color col1 = (int)random(255), col2 = (int)random(255), col3 = (int)random(255);
  int alpha = 150;
  float size;

  Particle(float size_temp) {
    size = size_temp;

    this.pos = new PVector(mouseX, mouseY);
  }

  void update() {
    size += 2;
    alpha -= 4;
    
    fill(col1, col2, col3, alpha);
    noStroke();
    ellipse(this.pos.x, this.pos.y, size, size);
  }
}

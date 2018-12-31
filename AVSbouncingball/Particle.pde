class Particle {

  PVector pos, 
    vel;
  int life, 
    col1, 
    col2, 
    col3;
  float mouseXVel, 
    mouseYVel, 
    size, 
    bounciness;

  Particle(float mouseXVel_temp, float mouseYVel_temp, int col1_temp, int col2_temp, int col3_temp, float size_temp, float bounciness_temp) {
    size = size_temp;
    col1 = col1_temp;
    col2 = col2_temp;
    col3 = col3_temp;
    mouseXVel = mouseXVel_temp;
    mouseYVel = mouseYVel_temp;
    bounciness = bounciness_temp;

    this.pos = new PVector(mouseX, mouseY);
    this.vel = new PVector(random(-2, 2) - mouseXVel, random(-2, 2) - mouseYVel);
    this.life = 255;
  }

  void update() {
    
    fill(col1, col2, col3, 100);
    noStroke();
    ellipse(this.pos.x, this.pos.y, size, size);

    if (this.pos.x < 0) {
      this.pos.x = .1;
      this.vel.x *= -bounciness;
    }

    if (this.pos.x > width) {
      this.pos.x = width - .1;
      this.vel.x *= -bounciness;
    }

    if (this.pos.y < 0) {
      this.pos.y = .1;
      this.vel.y *= -bounciness;
    }

    if (this.pos.y > height) {
      this.pos.y = height - .1;
      this.vel.y *= -bounciness;
    }

    this.pos.add(this.vel);
    this.vel.add(g);
  }
}

class Particle {

  PVector pos, 
    vel;
  int life, 
    col1, 
    col2, 
    col3;
  float mouseXVel, 
    mouseYVel, 
    size;

  Particle(float mouseXVel_temp, float mouseYVel_temp, int col1_temp, int col2_temp, int col3_temp, float size_temp) {
    size = size_temp;
    col1 = col1_temp;
    col2 = col2_temp;
    col3 = col3_temp;
    mouseXVel = mouseXVel_temp;
    mouseYVel = mouseYVel_temp;

    this.pos = new PVector(mouseX, mouseY);
    this.vel = new PVector(random(-2, 2) - mouseXVel, random(-2, 2) - mouseYVel);
    this.life = 255;
  }

  void update() {
    size -= .2;
    if (size > 0) {
      fill(col1, col2, col3, 100);
      noStroke();
      ellipse(this.pos.x, this.pos.y, size, size);
    }

    if (dist(this.pos.x, this.pos.y, groundEllipseX, groundEllipseY) <= (this.size / 2) + (groundEllipseD / 2)) {
      this.vel.y *= -0.6;
      this.pos.y -= 1;
    }
    
    if (dist(this.pos.x, this.pos.y, flyingEllipseX, flyingEllipseY) <= (this.size / 2) + (flyingEllipseD / 2)) {
      
      float X = this.pos.x - flyingEllipseX;
      float Y = this.pos.y - flyingEllipseY;
      
      float angle = atan(X/Y);
      
      println("angle = "+angle);
      println("x = "+ cos(angle));
      println("y = "+ sin(angle));
      
      //this.vel.x += sin(angle) * this.vel.x * -1;
      //this.vel.y += cos(angle) * this.vel.y * -1;
      
      //WIP!!!
    }

    if (this.pos.x < 0) {
      this.pos.x = 1;
      this.vel.x *= -0.6;
    }
    
    if (this.pos.x > width) {
      this.pos.x = width - 1;
      this.vel.x *= -0.6;
    }

    if (this.pos.y < 0) {
      this.pos.y = 1;
      this.vel.y *= -0.2;
    }

    this.pos.add(this.vel);
    this.vel.add(g);
  }
}

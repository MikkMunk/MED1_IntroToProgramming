PVector g = new PVector(0, .3);
ArrayList<Particle> particles;

float mouseXPre, 
  mouseXDif, 
  mouseYPre, 
  mouseYDif;

void setup() {
  size(1200, 800);

  particles = new ArrayList<Particle>();
}

void draw() {
  background(255);

  mouseXDif = mouseXPre - mouseX;
  mouseYDif = mouseYPre - mouseY;
  mouseXPre = mouseX;
  mouseYPre = mouseY;

  particles.add(new Particle(mouseXDif, mouseYDif, (int)random(255), (int)random(255), (int)random(255), random(20, 70)));

  for (int i = particles.size()-1; i >= 0; i--) {
    particles.get(i).update();

    if (particles.get(i).size < 0) {
      particles.remove(i);
    }
  }
  
  fill(0, 220, 50, 100);
  ellipse(width / 2, height * 2, height * 2.5, height * 2.5);
}

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
    
    if(dist(this.pos.x, this.pos.y, width / 2, height * 2) <= (this.size / 2) + ((height * 2.5) / 2)) {
      this.vel.y *= -0.6;
      this.pos.y -= 1; 
    }
    
    this.pos.add(this.vel);
    this.vel.add(g);
  }
}

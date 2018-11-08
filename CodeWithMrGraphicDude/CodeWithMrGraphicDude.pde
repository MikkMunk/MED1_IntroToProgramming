PVector g = new PVector(0, .3);
ArrayList<Particle> particles;

float mouseXPre, 
  mouseXDif, 
  mouseYPre, 
  mouseYDif, 
  groundEllipseX, 
  groundEllipseY, 
  groundEllipseD, 
  flyingEllipseX, 
  flyingEllipseY, 
  flyingEllipseD;

void setup() {
  size(1200, 800);

  groundEllipseX = width / 2;
  groundEllipseY = height * 2;
  groundEllipseD = height * 2.5;

  flyingEllipseX = width / 3;
  flyingEllipseY = height / 3;
  flyingEllipseD = height * 0.3;

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
    
    //Use if you want particles to interact with each other
    /*for (int o = 0; o != i && o <= particles.size(); o++) {
     if (dist(particles.get(i).pos.x, particles.get(i).pos.y, particles.get(o).pos.x, particles.get(o).pos.y) <= (particles.get(i).size / 2) + (particles.get(o).size / 2)) {
     
     particles.get(i).vel.y *= -0.6;
     particles.get(i).pos.y -= 1;
     }
     }*/

    if (particles.get(i).size < 0) {
      particles.remove(i);
    }
  }

  fill(0, 220, 50, 100);
  ellipse(groundEllipseX, groundEllipseY, groundEllipseD, groundEllipseD);

  fill(255, 255, 0, 130);
  ellipse(flyingEllipseX, flyingEllipseY, flyingEllipseD, flyingEllipseD);
}

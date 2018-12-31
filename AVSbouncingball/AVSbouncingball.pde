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

  for (int i = particles.size()-1; i >= 0; i--) {
    particles.get(i).update();
  }

  /*fill(0, 220, 50, 100);
   ellipse(groundEllipseX, groundEllipseY, groundEllipseD, groundEllipseD);
   
   fill(255, 255, 0, 130);
   ellipse(flyingEllipseX, flyingEllipseY, flyingEllipseD, flyingEllipseD);*/
}

void mousePressed() {
  particles.add(new Particle(mouseXDif, mouseYDif, (int)random(255), (int)random(255), (int)random(255), random(20, 70), 1));
  
  if (particles.size() > 1) {
      particles.remove(0);
   }
}

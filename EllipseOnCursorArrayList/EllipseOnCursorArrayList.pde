ArrayList<Particle> particles;

void setup() {
  size(1200, 800);
  noCursor();
  
  particles = new ArrayList<Particle>();
}

void draw() {
  background(0);

  particles.add(new Particle(0));
  
  for (int i = particles.size()-1; i >= 0; i--) {
    particles.get(i).update();
    
    if (particles.get(i).alpha <= 0) {
      particles.remove(i);
    }
  }
}

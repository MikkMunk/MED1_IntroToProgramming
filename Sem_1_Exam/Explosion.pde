class Explosion {
  
  int fadeSpeed = 30;
  
  int[] x = {0, 5, 6, 15, 4}, 
    y = {-10, -15, -10, -11, -9}; 

  float xPos = mouseX, 
    yPos = mouseY, 
    alpha = 255;

  Explosion() {
  }

  void update() {
    alpha -= fadeSpeed;

    pushMatrix();
    translate(xPos, yPos);
    fill(255,255,0,alpha);
    beginShape();
    vertex(x[0], y[0]);
    vertex(x[1], y[1]);
    vertex(x[2], y[2]);
    vertex(x[3], y[3]);
    vertex(x[4], y[4]);
    //vertex(x[5], y[5]);
    endShape(CLOSE);
    popMatrix();
  }
}

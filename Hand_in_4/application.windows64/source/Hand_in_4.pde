int stepX = 40;
int stepY = 30;

boolean clicked = false;

void setup() {
  size(800, 600);

  /*for (int i = 0; i <= height; i += 1) { //a
   line(0, stepY * i, width, stepY * i);
   }
   
   for (int i = 0; i <= width; i += 1) { //b
   line(stepX * i, 0, stepX * i, height);
   }*/

  for (int x = 0; x < width; x += stepX) {  //c
    for (int y = 0; y < height; y += stepY) { 
      fill(random(255));
      rect(x, y, stepX, stepY);
    }
  }
}

void draw() {
  if (clicked == true) {
    fill(random(255), 0, 0);
    int x = (mouseX / stepX) * stepX;
    int y = (mouseY / stepY) * stepY;
    rect(x, y, stepX, stepY);
  }
}

void mousePressed() {
  clicked = true;
}

void mouseReleased() {
  clicked = false;
}

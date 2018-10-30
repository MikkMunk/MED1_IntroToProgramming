import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Hand_in_4 extends PApplet {

int stepX = 40;
int stepY = 30;

boolean clicked = false;

public void setup() {
  

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

public void draw() {
  if (clicked == true) {
    fill(random(255), 0, 0);
    int x = (mouseX / stepX) * stepX;
    int y = (mouseY / stepY) * stepY;
    rect(x, y, stepX, stepY);
  }
}

public void mousePressed() {
  clicked = true;
}

public void mouseReleased() {
  clicked = false;
}
  public void settings() {  size(800, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Hand_in_4" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

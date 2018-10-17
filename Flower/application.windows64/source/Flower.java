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

public class Flower extends PApplet {

ArrayList<Flowerbud> flowers;

int r=60;
float ballX;
float ballY;

int flowerAmount = 50;

public void setup() {
  
  background(0xff08FAEC);
  

  flowers = new ArrayList<Flowerbud>();
}

public void draw()
{
  background(0xff08FAEC);
  if (flowers.size() < flowerAmount) {
    flowers.add(new Flowerbud(random(width), random(height), (int)random(3, 12), random(10, 100), color(random(255), random(255), random(255)), (int)random(2)));
  }

  for (int i = flowers.size()-1; i >= 0; i--) {
    Flowerbud flower = flowers.get(i);
    flower.display();
  }
  if (flowers.size() == flowerAmount) {
    flowers.remove(0);
  }
}

class Flowerbud 
{
  float xPos, yPos, radius;
  int petalAmount, centerColour;
  int petalColour;

  Flowerbud(float x, float y, int n_petals, float r, int petalCol, int centerCol) 
  {
    xPos = x;
    yPos = y;
    petalAmount = n_petals;
    radius = r;
    petalColour = petalCol;
    centerColour = centerCol;
  }

  public void display() 
  {
    fill(petalColour);
    for (float i = 0; i < PI*2; i += 2 * PI/petalAmount) {
      ballX = xPos + radius*cos(i);
      ballY = yPos + radius*sin(i);
      ellipse(ballX, ballY, radius, radius);
    }
    if (centerColour == 1) {
      fill(255, 255, 0);
    } else {
      fill(255, 0, 0);
    }
    ellipse(xPos, yPos, radius*1.2f, radius*1.2f);
  }
}

public void mousePressed() 
{
  flowers.add(new Flowerbud(mouseX, mouseY, (int)random(3, 12), random(10, 100), color(random(255), random(255), random(255)), (int)random(2)));

  flowers.remove(0);
}
  public void settings() {  size(1200, 800);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Flower" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

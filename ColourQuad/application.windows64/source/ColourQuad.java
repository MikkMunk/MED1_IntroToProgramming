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

public class ColourQuad extends PApplet {

public void setup() { //I'm executing the initial code to create my drawing. I needed the setup() function in order to have my draw() function work, later on
   //window viewport size
  background(0xffA3EAE0); //color for sky

  noStroke(); //We want our following shapes to have no outlines (strokes)

  //grass
  fill(0xff2F8E21); //fill color for grass surface
  rect(0, 280, 600, 120); //grass size and position values

  //sun
  fill(0xffFEFF2E); //fill color for sun
  ellipse(500, 120, 110, 110); //sun size and position values

  //square
  stroke(0xff000000); //black outlines
  strokeWeight(2); //width (weight) of the outlines

  //The following quads indicate each face of the cube, with the fill being the coloration
  fill(209, 80, 119, 120);
  quad(200, 300, 290, 360, 290, 240, 200, 180);
  
  fill(33, 38, 155, 120);
  quad(80, 320, 200, 300, 200, 180, 80, 200);
  
  fill(27, 227, 39, 120);
  quad(80, 320, 170, 380, 290, 360, 200, 300);
  
  fill(210, 237, 60, 120);
  quad(80, 200, 170, 260, 290, 240, 200, 180);
  
  fill(242, 55, 22, 120);
  quad(80, 320, 170, 380, 170, 260, 80, 200);
  
  fill(57, 51, 50, 120);
  quad(170, 380, 290, 360, 290, 240, 170, 260);
  
  save("homework1.jpg"); //I'm using this to save the final image as a jpg file
  //I realize there's a 3D box() method, but I'm sticking with 2D primitives for the sake of the assignment
}

public void draw() { //The draw function executes its code continuously
  println(mouseX); //I'm using this to find the X coordinates for the vertices of my square
  println(mouseY); //I'm using this to find the Y coordinates for the vertices of my square
}
  public void settings() {  size(600, 400); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ColourQuad" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

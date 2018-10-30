float topRightBackX = 80;
float topRightBackY = 200;
float topBackLeftX = 200;
float topBackLeftY = 180;
float topLeftFrontX = 290;
float topLeftFrontY = 240;
float topFrontRightX = 170;
float topFrontRightY = 260;
float bottomRightBackX = 80;
float bottomRightBackY = 320;
float bottomBackLeftX = 200;
float bottomBackLeftY = 300;
float bottomLeftFrontX = 290;
float bottomLeftFrontY = 360;
float bottomFrontRightX = 170;
float bottomFrontRightY = 380;

float speedValue = 0.1;

color leftFaceCol = color(209, 80, 119, 120);
color backFaceCol = color(33, 38, 155, 120);
color bottomFaceCol = color(27, 227, 39, 120);
color topFaceCol = color(210, 237, 60, 120);
color rightFaceCol = color(242, 55, 22, 120);
color frontFaceCol = color(57, 51, 50, 120);

float drawStartPosX;
float drawStartPosY;

boolean keyUP = false;
boolean keyDown = false;
boolean keyLeft = false;
boolean keyRight = false;

void setup() { //I'm executing the initial code to create my drawing. I needed the setup() function in order to have my draw() function work, later on
  size(600, 400); //Window viewport size
  background(#A3EAE0); //Color for sky

  rectMode(CORNERS); //Change the way we're defining the rectangles
  stroke(#000000); //Black outlines
  strokeWeight(2); //Width (weight) of the outlines
}

void draw() { //The draw function executes its code continuously
  background(#A3EAE0); //color for sky

  //The following quads indicate each face of the cube, with the fill being the coloration
  fill(leftFaceCol);
  quad(
    bottomBackLeftX, bottomBackLeftY, 
    bottomLeftFrontX, bottomLeftFrontY, 
    topLeftFrontX, topLeftFrontY, 
    topBackLeftX, topBackLeftY); //left face

  fill(backFaceCol);
  quad(bottomRightBackX, bottomRightBackY, 
    bottomBackLeftX, bottomBackLeftY, 
    topBackLeftX, topBackLeftY, 
    topRightBackX, topRightBackY); //back face

  fill(bottomFaceCol);
  quad(bottomRightBackX, bottomRightBackY, 
    bottomFrontRightX, bottomFrontRightY, 
    bottomLeftFrontX, bottomLeftFrontY, 
    bottomBackLeftX, bottomBackLeftY); //bottom face

  fill(topFaceCol);
  quad(topRightBackX, topRightBackY, 
    topFrontRightX, topFrontRightY, 
    topLeftFrontX, topLeftFrontY, 
    topBackLeftX, topBackLeftY); //top face

  fill(rightFaceCol);
  quad(bottomRightBackX, bottomRightBackY, 
    bottomFrontRightX, bottomFrontRightY, 
    topFrontRightX, topFrontRightY, 
    topRightBackX, topRightBackY); //right face

  fill(frontFaceCol);
  quad(bottomFrontRightX, bottomFrontRightY, 
    bottomLeftFrontX, bottomLeftFrontY, 
    topLeftFrontX, topLeftFrontY, 
    topFrontRightX, topFrontRightY); //front face

  //save("homework1.jpg"); //I'm using this to save the final image as a jpg file
  //I realize there's a 3D box() method, but I'm sticking with 2D primitives for the sake of the assignment

  //println(mouseX); //I'm using this to find the X coordinates for the vertices of my square
  //println(mouseY); //I'm using this to find the Y coordinates for the vertices of my square

  if (topRightBackX < 120) {
    topRightBackX = topRightBackX + speedValue;
  }

  if (bottomRightBackX > 200) {
    topRightBackX = topRightBackX + (speedValue * 3);
  }

  topBackLeftX = topBackLeftX + speedValue;
  topLeftFrontX = topLeftFrontX + speedValue;
  topFrontRightX = topFrontRightX + speedValue;
  bottomRightBackX = bottomRightBackX + speedValue;
  bottomBackLeftX = bottomBackLeftX + speedValue;
  bottomLeftFrontX = bottomLeftFrontX + speedValue;
  bottomFrontRightX = bottomFrontRightX + speedValue;

  if (keyUP == true) {
     topLeftFrontY = topLeftFrontY - 1; 
  }
  if (keyDown == true) {
     topLeftFrontY = topLeftFrontY + 1; 
  }
  if (keyLeft == true) {
     topLeftFrontX = topLeftFrontX - 1; 
  }
  if (keyRight == true) {
     topLeftFrontX = topLeftFrontX + 1; 
  }
}

void keyPressed() {
  if (keyCode == UP) {
    keyUP = true;
  }
  if (keyCode == DOWN) {
    keyDown = true;
  }
  if (keyCode == LEFT) {
    keyLeft = true;
  }
  if (keyCode == RIGHT) {
    keyRight = true;
  }
}

void keyReleased() {
  if (keyCode == UP) {
    keyUP = false;
  }
  if (keyCode == DOWN) {
    keyDown = false;
  }
  if (keyCode == LEFT) {
    keyLeft = false;
  }
  if (keyCode == RIGHT) {
    keyRight = false;
  }
}

void mousePressed() {
  drawStartPosX = mouseX;
  drawStartPosY = mouseY;
}

void mouseDragged() {
  noStroke();
  fill(50, 50, 50, 255);
  rect(drawStartPosX, drawStartPosY, mouseX, mouseY);
}

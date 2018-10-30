/*ArrayList<Bullet> bullets;

int screenW = 800; //Saving view port dimension to place elements in relation
int screenH = 650;

color BGcol = #E3CE62; //A few variables to kick off the setup()
color strokeCol = 0;
int strokeWeight = 2;

int textSize = 32;  //Font modification
int textLeftMargin = 10;
int textLineSpacing = 40;

boolean activated = false; //The game will be considered active after a key input

float targetX = 400;
float targetY = 100;
int targetHitBox = 15;
int hitCount = 0;

boolean keyUp = false; //Arrow key states
boolean keyDown = false;
boolean keyLeft = false;
boolean keyRight = false;

int origo = 0; //Using this when placing elements at 0,0 in their own translated coordinate system

color tankCol = #29640A; //Modify tank color. Saving it outside the class so I can add more for multiple differently colored tanks

Tank tank = new Tank(screenW / 2, screenH / 2, tankCol); //Values for my tank. These will be carried over into the object and replaced by its own variables
Tank tank = new Tank(screenW / 2, screenH / 2, tankCol);

void setup() { //initial code. I need the setup() function in order to have my draw() function work, later on
  size(800, 650); //Window viewport width and height
  smooth(); //anti-alias
  background(BGcol); //Color for ground

  bullets = new ArrayList<Bullet>();

  rectMode(CENTER); //Change the way we're defining the rectangles
  stroke(strokeCol); //Black outlines
  strokeWeight(strokeWeight); //Width (weight) of the outlines
}

void draw() { //The draw function executes its code continuously
  background(BGcol); //color for ground

  fill(255, 0, 0);
  ellipse(targetX, targetY, 20, 20);

  for (int i = bullets.size()-1; i >= 0; i--) { 
    Bullet bullet = bullets.get(i);
    bullet.update();

    if (dist(bullet.xpos, bullet.ypos, targetX, targetY) < targetHitBox) {
      targetX = random(width);
      targetY = random(height);
      hitCount++;
    }

    if (bullet.xpos < 0 || bullet.xpos > width || bullet.ypos < 0 || bullet.ypos > height) {
      bullets.remove(i);
    }
  }  

  tank.update(); //Run the update() function in the tank class

  if (activated == false) { //Only show text until activated is true
    textSize(textSize);
    fill(0);
    text("Arrows to move", textLeftMargin, textLineSpacing);  //Text with instructions
    text("Space to shoot", textLeftMargin, textLineSpacing * 2);
  } else {
    textSize(textSize);
    fill(0);
    text("Hits: "+ hitCount, textLeftMargin, textLineSpacing); //Text with score
  }
}

class Tank {  //Declare tank class
  float xpos, //variables we'll be using for the tank. X position here
    ypos, //Y position
    rotateAngle, //Angle of the tanks rotation
    speed = 2.0, //Movementspeed of the tank
    rotateSpeed = 1, //Rotation speed
    bodyWidth = 40, //Size declarations
    bodyLength = 50, 
    barrelWidth = 10, 
    barrelLength = 40, 
    towerDiameter = 20;
  color col;

  Tank (float x, float y, color getCol) {  //Here I'm taking the values from when the tank was initiated, and carry them over to its internal variables
    xpos = x;
    ypos = y;
    col = getCol;
  }

  void update() {

    pushMatrix(); //Push a matrix stack to save the current transformations, this is so I can modify the system with translations and rotations, and then pop the previous settings after

    translate(xpos, ypos);  //Pushing a "ghost" coordinate system with its 0,0 at the specified points
    rotate(radians(rotateAngle)); //rotating the new invisible coordinate system

    if (keyUp == true) {
      xpos = xpos + sin(radians(rotateAngle)); //Interpolation for forward movement, based on rotation
      ypos = ypos - cos(radians(rotateAngle));
    }
    if (keyDown == true) {
      xpos = xpos - sin(radians(rotateAngle)); //Same, but backwards
      ypos = ypos + cos(radians(rotateAngle));
    }
    if (keyLeft == true) {
      rotateAngle = rotateAngle - rotateSpeed; //Rotate the tank with right/left arrows
    }
    if (keyRight == true) {
      rotateAngle = rotateAngle + rotateSpeed;
    }

    fill(col);  //Visuals for the tank
    rect(origo, origo, bodyWidth, bodyLength);
    rect(origo, origo - (bodyLength / 2), barrelWidth, barrelLength);
    ellipse(origo, origo, towerDiameter, towerDiameter);

    popMatrix(); //Restore the original coordinate system
  }
}

class Bullet { //This class is structured much the same way as the tank
  float xpos, 
    ypos, 
    speed = 10, 
    bulletDir, 
    diameter = 10;

  Bullet (float x, float y, float rot) {  
    xpos = x;
    ypos = y;
    bulletDir = rot;
  }

  void update() {
    pushMatrix();

    xpos = xpos + (sin(radians(bulletDir)) * speed);
    ypos = ypos - (cos(radians(bulletDir)) * speed);

    translate(xpos, ypos);
    rotate(radians(bulletDir));

    fill(0);
    ellipse(origo, origo, diameter, diameter);

    popMatrix();
  }
}

void keyPressed() { //Calls when a key is pressed
  if (activated == false) {
    activated = true;  //Make activated true, to hide text
  }

  if (key == ' ') {  //Hit spacebar, edit position and rotation of bullet based on tank values
    bullets.add(new Bullet(tank.xpos, tank.ypos, tank.rotateAngle));
  }

  if (keyCode == UP) {  //Change state of arrow keys
    keyUp = true;
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

void keyReleased() { //Calls when a key is released
  if (keyCode == UP) {  //Change state of arrow keys
    keyUp = false;
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
*/

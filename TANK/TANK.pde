import processing.sound.*;  //I made and added music/soundfiles, but it doesn't carry over with the .pde file, so I've written them out
SoundFile pop;
SoundFile bgm;

ArrayList<Tank> tanks;    //Naming two arraylist variables here to store my initated objects based on classes, later
ArrayList<Bullet> bullets;

color BGcol = #E3CE62; //A few variables to kick off the setup()
color strokeCol = 0;
int strokeWeight = 2;

int textSize = 32;  //Font modification
int textLeftMargin = 10;
int textRightMargin = 580;
int textLineSpacing = 40;

boolean activated = false;  //The game will be considered active after a key input
int winningScore = 50;      //Score limit to "win" the game
boolean winnerFound = false;  //Winning state to stop counting hits

float pickupX;   //Coordinates and size for the orange pickup
float pickupY;
float pickupDiameter = 20;
color pickupCol = #FF7D00;

int pickupHitBox = 30;  //Distance to activate the pickup
int tankHitBox = 25;    //Distance for bullets to hit tanks

int origo = 0; //Using this when placing elements at 0,0 in their own translated coordinate system

color tankPlayerCol; //Tank tower color, to indicate player specific tanks. This will be randomized per player later.

int playerAmount = 2;

void setup() { //Initial code. I need the setup() function in order to have my draw() function work, later on
  size(800, 650); //Window viewport width and height
  smooth(); //Anti-alias
  background(BGcol); //Color for ground

  bullets = new ArrayList<Bullet>();  //Creating the two arraylists
  tanks = new ArrayList<Tank>();

  bgm = new SoundFile(this, "TANK.wav");
  pop = new SoundFile(this, "pop.wav");

  bgm.loop();
  
  rectMode(CENTER); //Change the way we're defining the rectangles
  stroke(strokeCol); //Black outlines
  strokeWeight(strokeWeight); //Width (weight) of the outlines
  pickupX = random(width);  //Randomizing position for the pickup
  pickupY = random(height);
}

void draw() { //The draw function executes its code continuously
  background(BGcol); //Color for background, which is the ground layer because of the topdown view.

  fill(pickupCol);    //initiating pickup
  ellipse(pickupX, pickupY, pickupDiameter, pickupDiameter);
  ellipse(pickupX, pickupY, pickupDiameter * 0.5, pickupDiameter * 0.5);

  if (tanks.size() < playerAmount) {  //Run this one time for every "playerAmount"
    tankPlayerCol = color(int(random(256)), int(random(256)), int(random(256))); //Since random() gives me a value between 0 and counting up with the value of the parameter, 256 should give me from 0 to 255, hence a binary number
    tanks.add(new Tank(random(width), random(height), tankPlayerCol)); //Add tanks based on the Tank class, with random positions and colors based on the previous randomization
  }

  for (int i = bullets.size()-1; i >= 0; i--) {  //Running for loop for ever bullet instantiated
    Bullet bullet = bullets.get(i); //Storing the current bullet(i) as simply bullet
    bullet.update();   //Making sure to run the update function for the bullet, in the Bullet class

    if ((dist(bullet.xpos, bullet.ypos, tanks.get(1).xpos, tanks.get(1).ypos) < tankHitBox) && winnerFound == false) {  //Remove bullet and add to player 2's hit score, whenever the distance between a bullet and tank goes below a limit. This also only works when the win state is still false
      bullets.remove(i);
      tanks.get(0).hitCount++;
    }

    if ((dist(bullet.xpos, bullet.ypos, tanks.get(0).xpos, tanks.get(0).ypos) < tankHitBox) && winnerFound == false) {  //Same here, but for player 1
      bullets.remove(i);
      tanks.get(1).hitCount++;
    }

    if (bullet.bounces <=0 && (bullet.xpos <= origo || bullet.xpos >= width || bullet.ypos <= origo || bullet.ypos >= height)) { //remove bullets when they're out of bounces
      bullets.remove(i);
    } 

    if (bullet.bounces > 0 && (bullet.xpos <= origo || bullet.xpos >= width)) { //Redirect bullets when they can still bounce and hit the sides of the view port
      bullet.bulletDir *= -1;  //I can simply take the negative value of their current rotation to do this
      bullet.bounces--;  //Subtract from bounces remaining amount
    }

    if (bullet.bounces > 0 && bullet.ypos <= origo || bullet.ypos >= height) { //Having difficulties coming up with the right equation to bounce off the top and bottom, but this works somewhat with a few issues
      bullet.bulletDir *= -cos(radians(bullet.bulletDir));
      bullet.bulletDir += 180;
      bullet.bounces--;
    }
  }

  for (int i = tanks.size()-1; i >= 0; i--) {  //Running loop for the tanks, same as the bullets
    Tank tank = tanks.get(i);
    tank.update();

    if ((dist(tanks.get(i).xpos, tanks.get(i).ypos, pickupX, pickupY) < pickupHitBox) && winnerFound == false) {  //Check if tanks are within set distance of the pickup, to reposition the pickup, and add points to the player
      pickupX = random(width);
      pickupY = random(height);
      tanks.get(i).hitCount += 10;
    }
  }

  if (activated == false) { //Only show instruction text until activated is true
    textSize(textSize);
    fill(0);
    text("Player 1:", textLeftMargin, textLineSpacing);
    text("'WASD' to move", textLeftMargin, textLineSpacing * 2);
    text("'Q' to shoot", textLeftMargin, textLineSpacing * 3);

    text("Player 2:", textLeftMargin, textLineSpacing * 5);
    text("Arrows to move", textLeftMargin, textLineSpacing * 6);
    text("'L' to shoot", textLeftMargin, textLineSpacing * 7);
  } else if (tanks.get(0).hitCount >= winningScore || tanks.get(1).hitCount >= winningScore) {  //If one of the players' hitCount is above the win amount, show what player won
    if (tanks.get(0).hitCount >= winningScore) {
      fill(tanks.get(0).playerCol);
      text("Player 2 wins!", textRightMargin, textLineSpacing);
    } 
    if (tanks.get(1).hitCount >= winningScore) {
      fill(tanks.get(1).playerCol);
      text("Player 1 wins!", textLeftMargin, textLineSpacing);
    }
    winnerFound = true;
  } else {                 //Otherwise show hitCount for each player
    textSize(textSize);
    fill(tanks.get(1).playerCol);
    text("Hits: "+ tanks.get(1).hitCount, textLeftMargin, textLineSpacing);
    fill(tanks.get(0).playerCol);
    text("Hits: "+ tanks.get(0).hitCount, textRightMargin, textLineSpacing);
  }
}

class Tank {  //Declare tank class
  float xpos, //variables we'll be using for the tank. X position here
    ypos, //Y position
    rotateAngle, //Angle of the tanks rotation
    speed = 2.0, //Movementspeed of the tank
    rotateSpeed = 1.5, //Rotation speed
    bodyWidth = 40, //Size declarations
    bodyLength = 50, 
    barrelWidth = 10, 
    barrelLength = 40, 
    towerDiameter = 20;

  int hitCount = 0;

  boolean keyUp = false, keyDown = false, keyLeft = false, keyRight = false;//Arrow key states
  boolean tankFireReady = true;

  color col = #29640A, playerCol; //tank body and tower color. The tower color will be randomly selected to help players find themselves

  Tank (float x, float y, color getPlayerCol) {  //Here I'm taking the values from when the tank was initiated, and carry them over to its internal variables
    xpos = x;
    ypos = y;
    playerCol = getPlayerCol;
  }

  void update() {

    pushMatrix(); //Push a matrix stack to save the current transformations, this is so I can modify the system with translations and rotations, and then pop the previous settings after

    translate(xpos, ypos);  //Pushing a "ghost" coordinate system with its 0,0 at the specified points
    rotate(radians(rotateAngle)); //rotating the new invisible coordinate system

    if (keyUp == true) {
      xpos = (xpos + sin(radians(rotateAngle)) * speed); //Interpolation for forward movement, based on rotation
      ypos = (ypos - cos(radians(rotateAngle)) * speed);
    }
    if (keyDown == true) {
      xpos = (xpos - sin(radians(rotateAngle)) * speed); //Same, but backwards
      ypos = (ypos + cos(radians(rotateAngle)) * speed);
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
    fill(playerCol);
    ellipse(origo, origo, towerDiameter, towerDiameter);

    popMatrix(); //Restore the original coordinate system
  }
}

class Bullet { //This class is structured much the same way as the tank class
  float xpos, 
    ypos, 
    speedModifier = 5, 
    bulletDir, 
    diameter = 10;

  int bounces = 1000;

  Bullet (float x, float y, float rot) {  
    xpos = x;
    ypos = y;
    bulletDir = rot;
  }

  void update() {
    pushMatrix();

    xpos = xpos + (sin(radians(bulletDir)) * speedModifier);
    ypos = ypos - (cos(radians(bulletDir)) * speedModifier);

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

  if (key == 'r') {   //Reset the win state and hitCounts to false and 0 respecively, in order to "restart" the game
    winnerFound = false;
    tanks.get(0).hitCount = 0;
    tanks.get(1).hitCount = 0;
  }

  if (key == 'l') {  //Hit l, edit position and rotation of bullet based on tank values
    bullets.add(new Bullet(tanks.get(0).xpos + (tanks.get(0).barrelLength * sin(radians(tanks.get(0).rotateAngle))), tanks.get(0).ypos - (tanks.get(0).barrelLength * cos(radians(tanks.get(0).rotateAngle))), tanks.get(0).rotateAngle));
    pop.play();
  }

  if (key == 'q') {  //Hit q, edit position and rotation of bullet based on tank values
    bullets.add(new Bullet(tanks.get(1).xpos + (tanks.get(1).barrelLength * sin(radians(tanks.get(1).rotateAngle))), tanks.get(1).ypos - (tanks.get(1).barrelLength * cos(radians(tanks.get(1).rotateAngle))), tanks.get(1).rotateAngle));
    pop.play();
  }

  if (keyCode == UP) {  //Arrow keys to control player 2's tank
    tanks.get(0).keyUp = true;
  }
  if (keyCode == DOWN) {
    tanks.get(0).keyDown = true;
  }
  if (keyCode == LEFT) {
    tanks.get(0).keyLeft = true;
  }
  if (keyCode == RIGHT) {
    tanks.get(0).keyRight = true;
  }

  if (key == 'w') {  //WASD keys to control player 1's tank
    tanks.get(1).keyUp = true;
  }
  if (key == 's') {
    tanks.get(1).keyDown = true;
  }
  if (key == 'a') {
    tanks.get(1).keyLeft = true;
  }
  if (key == 'd') {
    tanks.get(1).keyRight = true;
  }
}

void keyReleased() { //Calls when a key is released
  if (keyCode == UP) { //Arrow keys to control player 2's tank
    tanks.get(0).keyUp = false;
  }
  if (keyCode == DOWN) {
    tanks.get(0).keyDown = false;
  }
  if (keyCode == LEFT) {
    tanks.get(0).keyLeft = false;
  }
  if (keyCode == RIGHT) {
    tanks.get(0).keyRight = false;
  }

  if (key == 'w') {   //WASD keys to control player 1's tank
    tanks.get(1).keyUp = false;
  }
  if (key == 's') {
    tanks.get(1).keyDown = false;
  }
  if (key == 'a') {
    tanks.get(1).keyLeft = false;
  }
  if (key == 'd') {
    tanks.get(1).keyRight = false;
  }
}

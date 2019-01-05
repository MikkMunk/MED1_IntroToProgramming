import processing.sound.*; //Declaration of variables for sound effects.
SoundFile playerFireSFX;
SoundFile playerHitSFX;
SoundFile towerFireSFX;
SoundFile towerHitSFX;
SoundFile towerDeathSFX;

ArrayList<Area> areas; //Declaration of arraylists and arrays.
ArrayList<EnemyBullet> enemyBullets;
ArrayList<PlayerBullet> playerBullets;
ArrayList<EnemyTower> enemyTowers;
ArrayList<Wall> walls;
ArrayList<Explosion> explosions;
Player player;
UserInterface ui;

int areaNumber, 
  score, 
  timerMax = 10800, //Three minutes in seconds multiplied by the framerate of 60 per second. 
  timerCurrent = timerMax;

float xPosPlayer, 
  yPosPlayer, 
  finalScore, 
  areaXPos, 
  areaYPos, 
  areaXPosPre, 
  areaYPosPre, 
  areaXPosVector, 
  areaYPosVector, 
  rotation, 
  moveSpeed = 3, 
  moveRotation, 
  enemyInteractionDistance;

int enemyBulletSize = 10, 
  enemyBulletStrokeSize = enemyBulletSize/5;

color backgroundCol = #EAC766, 
  enemyBulletFillCol = #FC2008, 
  enemyBulletStrokeCol = #583430;

boolean gamePaused = true, 
  keyUp = false, 
  keyDown = false, 
  keyLeft = false, 
  keyRight = false, 
  cantUp = false, 
  cantDown = false, 
  cantLeft = false, 
  cantRight = false;

void setup() {
  //size(1200, 800);
  fullScreen();
  smooth();
  noStroke();
  textAlign(CENTER, CENTER);
  rectMode(CENTER);

  xPosPlayer = width/2; //Get values for center of screen for the player.
  yPosPlayer = height/2;
  enemyInteractionDistance = width/2;

  playerFireSFX = new SoundFile(this, "playerFireSFX.wav"); //Import soundfiles.
  playerHitSFX = new SoundFile(this, "playerHitSFX.wav");
  towerFireSFX = new SoundFile(this, "towerFireSFX.wav");
  towerHitSFX = new SoundFile(this, "towerHitSFX.wav");
  towerDeathSFX = new SoundFile(this, "towerDeathSFX.wav");

  areas = new ArrayList<Area>(); //Import array data types.
  enemyBullets = new ArrayList<EnemyBullet>();
  playerBullets = new ArrayList<PlayerBullet>();
  enemyTowers = new ArrayList<EnemyTower>();
  walls = new ArrayList<Wall>();
  explosions = new ArrayList<Explosion>();
  player = new Player(xPosPlayer, yPosPlayer);
  ui = new UserInterface();

  reset(); //Run reset function. This is also run whenever "r" is hit, and resets all values back to their initial ones, "resetting" the game.
}

void draw() {
  //background(backgroundCol);

  if (timerCurrent > 0 && !gamePaused) { //Only count down the timer whenever the game is not in a paused state. If this was not done, the clock would continue counting into negative.
    timerCurrent--;
  } 

  float x = mouseX - xPosPlayer; //Find the angle in radians based on two points in two axis planes. By subtracting one point with the axis value of the other, the first point can be replaced by 0,0, with the second having a vector direction based on the subtraction.
  float y = mouseY - yPosPlayer;
  rotation = atan2(y, x);

  if (touchingUp()) { //Control booleans for the player.
    cantUp = true;
  } else {
    cantUp = false;
  }
  if (touchingDown()) {
    cantDown = true;
  } else {
    cantDown = false;
  }
  if (touchingLeft()) {
    cantLeft = true;
  } else {
    cantLeft = false;
  }
  if (touchingRight()) {
    cantRight = true;
  } else {
    cantRight = false;
  }

  if (keyUp) {
    moveRotation = PI*1.5; //Save key direction as rotation value.
  }
  if (keyDown) {
    moveRotation = PI*.5;
  }
  if (keyLeft) {
    moveRotation = PI;
  }
  if (keyRight) {
    moveRotation = PI*2;
  }
  if (keyUp && keyLeft) {
    moveRotation = PI*1.25;
  }
  if (keyUp && keyRight) {
    moveRotation = PI*1.75;
  }
  if (keyDown && keyLeft) {
    moveRotation = PI*.75;
  }
  if (keyDown && keyRight) {
    moveRotation = PI*.25;
  }

  if (keyUp||keyDown||keyLeft||keyRight) {
    areaXPos += cos(moveRotation) * moveSpeed; //Move area position based on rotation. These position values are used to translate all objects other than the player, to animate movement.
    areaYPos += sin(moveRotation) * moveSpeed;

    areaXPosVector = areaXPosPre - areaXPos; //Save movement change per frame as a vector to move some elements such as bullets by the proper values.
    areaYPosVector = areaYPosPre - areaYPos;
    areaXPosPre = areaXPos;
    areaYPosPre = areaYPos;
  } else {
    areaXPosVector = 0; //Make sure to reset vector when nothing is pressed.
    areaYPosVector = 0;
  }

  for (int i = areas.size()-1; i >= 0; i--) { //Backwards looping through most arraylist items, since we are often adding and removing objects dynamically.
    areas.get(i).update();

    if ((areaXPos - areas.get(i).xPos) > width) { //These sections make sure that the game constantly exist of nine area each the size of the viewport. Screen width or height movement in either direction will remove the furthest areas and construct new ones in the movement direction.
      areas.add(new Area(areas.get(i).xPos + width*3, areas.get(i).yPos, areaNumber));
      updateAreas(i); //Run function to remove all objects attached to the removed areas.
    } else if ((areaXPos - areas.get(i).xPos) < -width*2) {
      areas.add(new Area(areas.get(i).xPos - width*3, areas.get(i).yPos, areaNumber));
      updateAreas(i);
    } else if ((areaYPos - areas.get(i).yPos) > height) {
      areas.add(new Area(areas.get(i).xPos, areas.get(i).yPos + height*3, areaNumber));
      updateAreas(i);
    } else if ((areaYPos - areas.get(i).yPos) < -height*2) {
      areas.add(new Area(areas.get(i).xPos, areas.get(i).yPos - height*3, areaNumber));
      updateAreas(i);
    }
  }

  for (int i = enemyBullets.size()-1; i >= 0; i--) { //Run all bullets from enemies.
    enemyBullets.get(i).update();

    if (enemyBullets.get(i).distanceFlown > enemyInteractionDistance) { //Remove when they have flown a set distance
      enemyBullets.remove(i);
    }
  }

  for (int i = playerBullets.size()-1; i >= 0; i--) { //Run bullets from player.
    playerBullets.get(i).update();

    if (playerBullets.get(i).distanceFlown > enemyInteractionDistance) { //Remove when they have flown a set distance
      playerBullets.remove(i);
    }
  }

  player.update(); //Run player.

  for (int i = walls.size()-1; i >= 0; i--) { //Run wall objects.
    walls.get(i).update();
  }

  for (int i = enemyTowers.size()-1; i >= 0; i--) { //Run enemy towers.
    enemyTowers.get(i).update();

    if (enemyTowers.get(i).healthCurrent <= 0) { //If enemy health hits 0,
      score++; //increase score,
      explosions.add(new Explosion(-areaXPos+enemyTowers.get(i).xPos, -areaYPos+enemyTowers.get(i).yPos, rotation, false, 0, true, false)); //add explosion effect,
      towerDeathSFX.play(); //play matching sound,
      enemyTowers.remove(i); //and remove the tower.
    }
  }

  for (int i = explosions.size()-1; i >= 0; i--) { //Run all explosions.
    explosions.get(i).update();

    if (explosions.get(i).alpha <= 0) { //Remove them if their alpha value goes to 0.
      explosions.remove(i);
    }
  }

  ui.update(); //Run ui. The order of running the objects is intentional, to set the layers of visibility.

  if (timerCurrent == 0 || player.healthCurrent == 0) { //Stop player interaction if health or timer goes to 0.
    keyUp = false;
    keyDown = false;
    keyLeft = false;
    keyRight = false;
    player.fireActive = false;
  }
}

void keyPressed() {
  if (gamePaused) { //Start game on clicking a button.
    gamePaused = false;
  }
  if (player.healthCurrent > 0 && timerCurrent > 0) { //Modify movement variables on keypresses as long as criteria is met.
    if (keyCode == UP || key == 'w' || key == 'W') {
      if (!cantUp) {
        keyUp = true;
      }
    }
    if (keyCode == DOWN || key == 's' || key == 'S') {
      if (!cantDown) {
        keyDown = true;
      }
    }
    if (keyCode == LEFT || key == 'a' || key == 'A') {
      if (!cantLeft) {
        keyLeft = true;
      }
    }
    if (keyCode == RIGHT || key == 'd' || key == 'D') {
      if (!cantRight) {
        keyRight = true;
      }
    }
  }
  if (key == 'r' || key == 'R') { //Hit "R" to run reset function and reset game state.
    reset();
  }
}

void keyReleased() {
  if (keyCode == UP || key == 'w' || key == 'W') { //Modify movement variables on key releases.
    keyUp = false;
  }
  if (keyCode == DOWN || key == 's' || key == 'S') {
    keyDown = false;
  }
  if (keyCode == LEFT || key == 'a' || key == 'A') {
    keyLeft = false;
  }
  if (keyCode == RIGHT || key == 'd' || key == 'D') {
    keyRight = false;
  }
}

void mousePressed() { 
  if (player.healthCurrent > 0 && timerCurrent > 0) { //Modify player shooting variable state.
    player.fireActive = true;
  }
}

void mouseReleased() {
  player.fireActive = false;
}

void updateAreas(int i) { //Function used to remove objects in removed areas. Each new area will be assigned a number from the areaNumber integer, which is then added to all objects in the area on creation. This function checks walls and towers for matching numbers and will delete them if so.
  areaNumber++;
  for (int j = enemyTowers.size()-1; j >= 0; j--) {
    if (enemyTowers.get(j).areaNumber == areas.get(i).number) {
      enemyTowers.remove(j);
    }
  }
  for (int j = walls.size()-1; j >= 0; j--) {
    if (walls.get(j).areaNumber == areas.get(i).number) {
      walls.remove(j);
    }
  }
  areas.remove(i);
}

boolean touchingUp() { //These four directional touchingX functions will run for each distance segment (lMulti) on every wall element. If the player is within a set distance of any of these, they will then each check to see where the player is positioned compared to itself, and return true if the direction fits their own. 
  for (int i = walls.size()-1; i >= 0; i--) {
    for (int j = 0; j <= walls.get(i).lMulti; j++) {
      walls.get(i).transXPos = ((walls.get(i).w/2) * j * sin(-walls.get(i).wallRotation));
      walls.get(i).transYPos = ((walls.get(i).w/2) * j * cos(walls.get(i).wallRotation));
      if (dist(player.xPos, player.yPos, -areaXPos+walls.get(i).xPos+walls.get(i).transXPos, -areaYPos+walls.get(i).yPos+walls.get(i).transYPos) <= ((walls.get(i).w/2)+(player.bodyWidth/2)) || dist(player.xPos, player.yPos, -areaXPos+walls.get(i).xPos-walls.get(i).transXPos, -areaYPos+walls.get(i).yPos-walls.get(i).transYPos) <= ((walls.get(i).w/2)+(player.bodyWidth/2))) {
        if (player.yPos > -areaYPos+walls.get(i).yPos+walls.get(i).transYPos || player.yPos > -areaYPos+walls.get(i).yPos-walls.get(i).transYPos) {
          keyUp = false;
          return true;
        }
      }
    }
  }
  return false;
}

boolean touchingDown() {
  for (int i = walls.size()-1; i >= 0; i--) {
    for (int j = 0; j <= walls.get(i).lMulti; j++) {
      walls.get(i).transXPos = ((walls.get(i).w/2) * j * sin(-walls.get(i).wallRotation));
      walls.get(i).transYPos = ((walls.get(i).w/2) * j * cos(walls.get(i).wallRotation));
      if (dist(player.xPos, player.yPos, -areaXPos+walls.get(i).xPos+walls.get(i).transXPos, -areaYPos+walls.get(i).yPos+walls.get(i).transYPos) <= ((walls.get(i).w/2)+(player.bodyWidth/2)) || dist(player.xPos, player.yPos, -areaXPos+walls.get(i).xPos-walls.get(i).transXPos, -areaYPos+walls.get(i).yPos-walls.get(i).transYPos) <= ((walls.get(i).w/2)+(player.bodyWidth/2))) {
        if (player.yPos < -areaYPos+walls.get(i).yPos+walls.get(i).transYPos || player.yPos < -areaYPos+walls.get(i).yPos-walls.get(i).transYPos) {
          keyDown = false;
          return true;
        }
      }
    }
  }
  return false;
}

boolean touchingLeft() {
  for (int i = walls.size()-1; i >= 0; i--) {
    for (int j = 0; j <= walls.get(i).lMulti; j++) {
      walls.get(i).transXPos = ((walls.get(i).w/2) * j * sin(-walls.get(i).wallRotation));
      walls.get(i).transYPos = ((walls.get(i).w/2) * j * cos(walls.get(i).wallRotation));
      if (dist(player.xPos, player.yPos, -areaXPos+walls.get(i).xPos+walls.get(i).transXPos, -areaYPos+walls.get(i).yPos+walls.get(i).transYPos) <= ((walls.get(i).w/2)+(player.bodyWidth/2)) || dist(player.xPos, player.yPos, -areaXPos+walls.get(i).xPos-walls.get(i).transXPos, -areaYPos+walls.get(i).yPos-walls.get(i).transYPos) <= ((walls.get(i).w/2)+(player.bodyWidth/2))) {
        if (player.xPos > -areaXPos+walls.get(i).xPos+walls.get(i).transXPos || player.xPos > -areaXPos+walls.get(i).xPos-walls.get(i).transXPos) {
          keyLeft = false;
          return true;
        }
      }
    }
  }
  return false;
}

boolean touchingRight() {
  for (int i = walls.size()-1; i >= 0; i--) {
    for (int j = 0; j <= walls.get(i).lMulti; j++) {
      walls.get(i).transXPos = ((walls.get(i).w/2) * j * sin(-walls.get(i).wallRotation));
      walls.get(i).transYPos = ((walls.get(i).w/2) * j * cos(walls.get(i).wallRotation));
      if (dist(player.xPos, player.yPos, -areaXPos+walls.get(i).xPos+walls.get(i).transXPos, -areaYPos+walls.get(i).yPos+walls.get(i).transYPos) <= ((walls.get(i).w/2)+(player.bodyWidth/2)) || dist(player.xPos, player.yPos, -areaXPos+walls.get(i).xPos-walls.get(i).transXPos, -areaYPos+walls.get(i).yPos-walls.get(i).transYPos) <= ((walls.get(i).w/2)+(player.bodyWidth/2))) {
        if (player.xPos < -areaXPos+walls.get(i).xPos+walls.get(i).transXPos || player.xPos < -areaXPos+walls.get(i).xPos-walls.get(i).transXPos) {
          keyRight = false;
          return true;
        }
      }
    }
  }
  return false;
}

void reset() { //This is ran with setup and whenever "R" is clicked. It resets all variables to their initial state, resetting the game.
  areaNumber = 0;
  areaXPos = 0;
  areaYPos = 0;
  gamePaused = true;
  player.healthCurrent = player.healthMax;
  score = 0;
  timerCurrent = timerMax;
  for (int i = areas.size()-1; i >= 0; i--) { //It also removes and recreates all areas along with their objects.
    for (int j = enemyTowers.size()-1; j >= 0; j--) {
      if (enemyTowers.get(j).areaNumber == areas.get(i).number) {
        enemyTowers.remove(j);
      }
    }
    for (int j = walls.size()-1; j >= 0; j--) {
      if (walls.get(j).areaNumber == areas.get(i).number) {
        walls.remove(j);
      }
    }
    areas.remove(i);
  }

  for (int x = -width; x <= width; x += width) {
    for (int y = -height; y <= height; y += height) {
      areas.add(new Area(xPosPlayer+x, yPosPlayer+y, areaNumber));
      areaNumber++;
    }
  }

  for (int i = enemyTowers.size()-1; i >= 0; i--) { //Make sure no towers spawn within fire distance to the player.
    if (dist(xPosPlayer, yPosPlayer, -areaXPos+enemyTowers.get(i).xPos, -areaYPos+enemyTowers.get(i).yPos) < enemyInteractionDistance) {
      enemyTowers.remove(i);
    }
  }

  for (int i = enemyBullets.size()-1; i >= 0; i--) {
    enemyBullets.remove(i);
  }

  for (int i = playerBullets.size()-1; i >= 0; i--) {
    playerBullets.remove(i);
  }
}

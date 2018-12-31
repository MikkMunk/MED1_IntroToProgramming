ArrayList<Area> areas;
ArrayList<EnemyBullet> enemyBullets;
ArrayList<PlayerBullet> playerBullets;
ArrayList<EnemyTower> enemyTowers;
Player player;

int areaNumber;

float xPosPlayer, 
  yPosPlayer, 
  areaXPos, 
  areaYPos, 
  areaXPosPre, 
  areaYPosPre, 
  areaXPosVector, 
  areaYPosVector, 
  rotation, 
  moveSpeed = 3, 
  moveRotation;

boolean keyUp = false, 
  keyDown = false, 
  keyLeft = false, 
  keyRight = false, 
  fireActive = false, 
  fireAltBarrel = false;

void setup() {
  size(1200, 800);
  //fullScreen();
  smooth();
  noStroke();
  rectMode(CENTER);

  xPosPlayer = width/2;
  yPosPlayer = height/2;

  areas = new ArrayList<Area>();
  enemyBullets = new ArrayList<EnemyBullet>();
  playerBullets = new ArrayList<PlayerBullet>();
  enemyTowers = new ArrayList<EnemyTower>();
  player = new Player(xPosPlayer, yPosPlayer);

  for (int x = -width; x <= width; x += width) {
    for (int y = -height; y <= height; y += height) {
      areas.add(new Area(xPosPlayer+x, yPosPlayer+y, areaNumber));
      areaNumber++;
    }
  }
}
void draw() {
  //background(#EAC766);

  float x = mouseX - xPosPlayer;
  float y = mouseY - yPosPlayer;
  rotation = atan2(y, x);

  if (keyUp) {
    moveRotation = PI*1.5;
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
    areaXPos = (areaXPos + cos(moveRotation) * moveSpeed);
    areaYPos = (areaYPos + sin(moveRotation) * moveSpeed);

    areaXPosVector = areaXPosPre - areaXPos;
    areaYPosVector = areaYPosPre - areaYPos;
    areaXPosPre = areaXPos;
    areaYPosPre = areaYPos;
  } else {
    areaXPosVector = 0;
    areaYPosVector = 0;
  }

  for (int i = areas.size()-1; i >= 0; i--) {
    areas.get(i).update();

    if ((areaXPos - areas.get(i).xPos) > width) {
      areas.add(new Area(areas.get(i).xPos + width*3, areas.get(i).yPos, areaNumber));
      updateAreas(i);
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

  for (int i = enemyTowers.size()-1; i >= 0; i--) {
    enemyTowers.get(i).update();

    if (enemyTowers.get(i).healthCurrent <= 0) {
      enemyTowers.remove(i);
    }
  }

  if (fireActive) {
    playerBullets.add(new PlayerBullet(xPosPlayer, yPosPlayer, rotation, player.turretRotation, fireAltBarrel));
    fireAltBarrel = !fireAltBarrel;
  }

  for (int i = enemyBullets.size()-1; i >= 0; i--) {
    enemyBullets.get(i).update();

    if (enemyBullets.get(i).distanceFlown > width/2) {
      enemyBullets.remove(i);
    }
  }

  for (int i = playerBullets.size()-1; i >= 0; i--) {
    playerBullets.get(i).update();

    if (playerBullets.get(i).distanceFlown > width/2) {
      playerBullets.remove(i);
    }
  }

  player.update();
  
  fill(0);
  text("Health: " + player.healthCurrent, width/10, height/10*9);
}

void keyPressed() {
  if (keyCode == UP || key == 'w' || key == 'W') {
    keyUp = true;
  }
  if (keyCode == DOWN || key == 's' || key == 'S') {
    keyDown = true;
  }
  if (keyCode == LEFT || key == 'a' || key == 'A') {
    keyLeft = true;
  }
  if (keyCode == RIGHT || key == 'd' || key == 'D') {
    keyRight = true;
  }
}

void keyReleased() {
  if (keyCode == UP || key == 'w' || key == 'W') {
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
  fireActive = true;
}

void mouseReleased() {
  fireActive = false;
}

void updateAreas(int i) {
  areaNumber++;
  for (int j = enemyTowers.size()-1; j >= 0; j--) {
    if (enemyTowers.get(j).areaNumber == areas.get(i).number) {
      enemyTowers.remove(j);
    }
  }
  areas.remove(i);
}

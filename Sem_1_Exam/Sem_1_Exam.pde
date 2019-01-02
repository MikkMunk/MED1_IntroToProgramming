ArrayList<Area> areas;
ArrayList<EnemyBullet> enemyBullets;
ArrayList<PlayerBullet> playerBullets;
ArrayList<EnemyTower> enemyTowers;
ArrayList<Wall> walls;
ArrayList<Explosion> explosions;
Player player;
UserInterface ui;

int areaNumber, 
  score,
  timerMax = 10800, //Three minutes in seconds multiplied by framerate. 
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
  moveRotation;

int enemyBulletSize = 10, 
  enemyBulletStrokeSize = enemyBulletSize/5;

color enemyBulletFillCol = #FC2008, 
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

  xPosPlayer = width/2;
  yPosPlayer = height/2;

  areas = new ArrayList<Area>();
  enemyBullets = new ArrayList<EnemyBullet>();
  playerBullets = new ArrayList<PlayerBullet>();
  enemyTowers = new ArrayList<EnemyTower>();
  walls = new ArrayList<Wall>();
  explosions = new ArrayList<Explosion>();
  player = new Player(xPosPlayer, yPosPlayer);
  ui = new UserInterface();

  reset();
}

void draw() {
  //background(#EAC766);

  if (timerCurrent > 0 && !gamePaused) {
    timerCurrent--;
  } 

  

  float x = mouseX - xPosPlayer;
  float y = mouseY - yPosPlayer;
  rotation = atan2(y, x);

  if (touchingUp()) {
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
    areaXPos += cos(moveRotation) * moveSpeed;
    areaYPos += sin(moveRotation) * moveSpeed;

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

  for (int i = walls.size()-1; i >= 0; i--) {
    walls.get(i).update();
  }

  for (int i = enemyTowers.size()-1; i >= 0; i--) {
    enemyTowers.get(i).update();

    if (enemyTowers.get(i).healthCurrent <= 0) {
      score++;
      explosions.add(new Explosion(-areaXPos+enemyTowers.get(i).xPos, -areaYPos+enemyTowers.get(i).yPos, rotation, false, 0, true, false));
      enemyTowers.remove(i);
    }
  }

  for (int i = explosions.size()-1; i >= 0; i--) {
    explosions.get(i).update();

    if (explosions.get(i).alpha <= 0) {
      explosions.remove(i);
    }
  }

  ui.update();
  if (timerCurrent == 0 || player.healthCurrent == 0) {
    keyUp = false;
    keyDown = false;
    keyLeft = false;
    keyRight = false;
    player.fireActive = false;
  }
}

void keyPressed() {
  if (gamePaused) {
    gamePaused = false;
  }
  if (player.healthCurrent > 0 && timerCurrent > 0) {
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
  if (key == 'r' || key == 'R') {
    reset();
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
  if (player.healthCurrent > 0 && timerCurrent > 0) {
    player.fireActive = true;
  }
}

void mouseReleased() {
  player.fireActive = false;
}

void updateAreas(int i) {
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

boolean touchingUp() {
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

void reset() {
  areaNumber = 0;
  areaXPos = 0;
  areaYPos = 0;
  gamePaused = true;
  player.healthCurrent = player.healthMax;
  score = 0;
  timerCurrent = timerMax;
  for (int i = areas.size()-1; i >= 0; i--) {
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

  for (int i = enemyTowers.size()-1; i >= 0; i--) {
    if (dist(xPosPlayer, yPosPlayer, -areaXPos+enemyTowers.get(i).xPos, -areaYPos+enemyTowers.get(i).yPos) < width/2) {
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

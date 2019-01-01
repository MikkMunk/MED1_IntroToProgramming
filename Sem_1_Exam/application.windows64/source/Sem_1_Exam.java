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

public class Sem_1_Exam extends PApplet {

ArrayList<Area> areas;
ArrayList<EnemyBullet> enemyBullets;
ArrayList<PlayerBullet> playerBullets;
ArrayList<EnemyTower> enemyTowers;
ArrayList<Wall> walls;
ArrayList<Explosion> explosions;
Player player;
UserInterface ui;

int areaNumber, 
  score;

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

int enemyBulletSize = 10, 
  enemyBulletStrokeSize = enemyBulletSize/5;

int enemyBulletFillCol = 0xffFC2008, 
  enemyBulletStrokeCol = 0xff583430;

boolean keyUp = false, 
  keyDown = false, 
  keyLeft = false, 
  keyRight = false,
  cantUp = false,
  cantDown = false,
  cantLeft = false,
  cantRight = false;

public void setup() {
  //size(1200, 800);
  
  
  noStroke();
  textAlign(CENTER, CENTER);
  textSize(30);
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
}

public void draw() {
  //background(#EAC766);

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
    moveRotation = PI*1.5f;
  }
  if (keyDown) {
    moveRotation = PI*.5f;
  }
  if (keyLeft) {
    moveRotation = PI;
  }
  if (keyRight) {
    moveRotation = PI*2;
  }
  if (keyUp && keyLeft) {
    moveRotation = PI*1.25f;
  }
  if (keyUp && keyRight) {
    moveRotation = PI*1.75f;
  }
  if (keyDown && keyLeft) {
    moveRotation = PI*.75f;
  }
  if (keyDown && keyRight) {
    moveRotation = PI*.25f;
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
}

public void keyPressed() {
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

public void keyReleased() {
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

public void mousePressed() {
  player.fireActive = true;
}

public void mouseReleased() {
  player.fireActive = false;
}

public void updateAreas(int i) {
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

public boolean touchingUp() {
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

public boolean touchingDown() {
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

public boolean touchingLeft() {
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

public boolean touchingRight() {
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

class Area {

  int towerAmount = (int)random(2, 5), 
    wallAmount = (int)random(2, 10);

  int[] towerX = new int[towerAmount], 
    towerY = new int[towerAmount], 
    wallX = new int[wallAmount], 
    wallY = new int[wallAmount];

  int size = 20, 
    strokeSize = size/4, 
    number;

  float xPos, 
    yPos;

  Area(float x_temp, float y_temp, int number_temp) {
    xPos = x_temp;
    yPos = y_temp;
    number = number_temp;

    for (int i = 0; i < towerAmount; i++) {
      towerX[i] = (int)xPos + (int)random(-width/2, width/2);
    }
    for (int i = 0; i < towerAmount; i++) {
      towerY[i] = (int)yPos + (int)random(-height/2, height/2);
    }
    if (number != 4) {
      for (int i = 0; i < towerAmount; i++) {
        enemyTowers.add(new EnemyTower(towerX[i], towerY[i], number));
      }
    }

    for (int i = 0; i < wallAmount; i++) {
      wallX[i] = (int)xPos + (int)random(-width/2, width/2);
    }
    for (int i = 0; i < wallAmount; i++) {
      wallY[i] = (int)yPos + (int)random(-height/2, height/2);
    }
    for (int i = 0; i < wallAmount; i++) {
      walls.add(new Wall(wallX[i], wallY[i], number));
    }
  }

  public void update() {
    pushMatrix();
    translate(-areaXPos, -areaYPos);

    fill(0xffEAC766);
    rect(xPos, yPos, width, height);

    stroke(0xffD1AA1E, 150);
    strokeWeight(strokeSize);
    ellipse(xPos, yPos, size, size);
    noStroke();

    popMatrix();
  }
}
class EnemyBullet {

  float xPos, 
    yPos, 
    bulletDir, 
    dirDeviation = radians(random(-10, 10)), 
    towerSize, 
    distanceFlown, 
    damage = 5;

  int speed = 10;

  EnemyBullet(float x_temp, float y_temp, float rot_temp, float towerSize_temp) {
    xPos = x_temp;
    yPos = y_temp;
    towerSize = towerSize_temp;
    bulletDir = rot_temp;

    xPos += (towerSize * cos(bulletDir));
    yPos += (towerSize * sin(bulletDir));
  }

  public void update() {

    distanceFlown += speed;
    xPos = (xPos + cos(bulletDir+dirDeviation) * speed);
    yPos = (yPos + sin(bulletDir+dirDeviation) * speed);
    xPos += areaXPosVector;
    yPos += areaYPosVector;

    pushMatrix();
    translate(xPos, yPos);

    fill(enemyBulletFillCol, 200);
    stroke(enemyBulletStrokeCol, 200);
    strokeWeight(enemyBulletStrokeSize);
    ellipse(0, 0, enemyBulletSize, enemyBulletSize);
    noStroke();
    popMatrix();
  }
}
class EnemyTower {

  int xPos, 
    yPos, 
    areaNumber;

  float towerRotation, 
    healthbarFill, 
    size = 40, 
    healthMax = 100, 
    healthCurrent = healthMax, 
    fireDelayValue = 60, 
    currentFireDelay = fireDelayValue;

  boolean fireReady = true;

  EnemyTower(int x_temp, int y_temp, int number_temp) {
    xPos = x_temp;
    yPos = y_temp;
    areaNumber = number_temp;
  }

  public void update() {
    pushMatrix();
    translate(-areaXPos, -areaYPos);

    float x = xPosPlayer - (-areaXPos+xPos);
    float y = yPosPlayer - (-areaYPos+yPos);
    towerRotation = atan2(y, x);

    pushMatrix();
    translate(xPos, yPos);

    if (healthCurrent < healthMax) {
      healthbarFill = size*(healthCurrent/healthMax);
      fill(255, 0, 0, 100);
      rect(0, -size, healthbarFill, size/10);
    }

    rotate(towerRotation);

    fill(0xff624541);
    ellipse(0, 0, size, size);
    for (int i = playerBullets.size()-1; i >= 0; i--) {
      if (dist(playerBullets.get(i).xPos, playerBullets.get(i).yPos, -areaXPos+xPos, -areaYPos+yPos) <= ((size/2)+(playerBullets.get(i).size/2))) {
        healthCurrent -= playerBullets.get(i).damage;
        playerBullets.remove(i);
      }
    }

    fill(0xffA03023);
    rect((size/2), 0, size, size/3);

    fill(0xffD6230F);
    ellipse(0, 0, size/2, size/2);

    popMatrix();
    popMatrix();

    if (!fireReady) {
      currentFireDelay--;
      if (currentFireDelay == 0) {
        fireReady = true;
        currentFireDelay = fireDelayValue;
      }
    }

    if (fireReady && dist(xPosPlayer, yPosPlayer, -areaXPos+xPos, -areaYPos+yPos) < width/2) {
      enemyBullets.add(new EnemyBullet(-areaXPos+xPos, -areaYPos+yPos, towerRotation, size));
      explosions.add(new Explosion(-areaXPos+xPos, -areaYPos+yPos, towerRotation, true, size, false, false));
      fireReady = false;
    }
  }
}
class Explosion {

  int fadeSpeed = 30;

  int[] x = {6, 6, 10, 8, 19, 8, 16, 4, 3, -1, -7, -7, -13, -9, -13, -10, -19, -6, -5, -2}, 
    y = {-19, -6, -7, -4, 0, 4, 12, 8, 14, 10, 19, 8, 9, 2, 0, -1, -7, -5, -11, -7}; 

  float xPos, 
    yPos, 
    rot, 
    towerSize, 
    alpha = 255, 
    randomRotation = random(360), 
    randomXScale = random(.8f, 1.2f), 
    randomYScale = random(.8f, 1.2f), 
    enemyDeathScale = 1, 
    centerScale = .5f;

  boolean enemyFire, 
    enemyDeath, 
    playerFireAlt;

  Explosion(float x_temp, float y_temp, float rot_temp, boolean enemyFire_temp, float towerSize_temp, boolean enemyDeath_temp, boolean fireAlt_temp) {
    xPos = x_temp;
    yPos = y_temp;
    rot = rot_temp;
    enemyFire = enemyFire_temp;
    enemyDeath = enemyDeath_temp;
    playerFireAlt = fireAlt_temp;

    if (!enemyFire && !enemyDeath) {
      if (playerFireAlt) {
        xPos += (player.turretPos * sin(rot)) + ((player.turretLength/2) * cos(rot));
        yPos -= (player.turretPos * cos(rot)) - ((player.turretLength/2) * sin(rot));
      } else {
        xPos -= (player.turretPos * sin(rot)) - ((player.turretLength/2) * cos(rot));
        yPos += (player.turretPos * cos(rot)) + ((player.turretLength/2) * sin(rot));
      }
    } else if (enemyFire) {
      towerSize = towerSize_temp;
      xPos += (towerSize * cos(rot));
      yPos += (towerSize * sin(rot));
    } else if (enemyDeath) {
      enemyDeathScale = 4;
    }
  }

  public void update() {
    alpha -= fadeSpeed;
    xPos += areaXPosVector;
    yPos += areaYPosVector;

    pushMatrix();
    translate(xPos, yPos);
    rotate(radians(randomRotation));

    fill(0xffFF3700, alpha);
    beginShape();
    for (int i = 0; i < x.length; i++) {
      vertex(x[i]*randomXScale*enemyDeathScale, y[i]*randomYScale*enemyDeathScale);
    }
    endShape(CLOSE);

    fill(0xffFFE200, alpha);
    beginShape();
    for (int i = 0; i < x.length; i++) {
      vertex(x[i]*randomXScale*centerScale*enemyDeathScale, y[i]*randomYScale*centerScale*enemyDeathScale);
    }
    endShape(CLOSE);

    popMatrix();
  }
}

class Player {

  float xPos, 
    yPos, 
    healthMax = 100, 
    healthCurrent = healthMax, 
    bodyRotation, 
    legMove = 0, 
    legMoveSpeed, 
    legRotation, 
    turretRotation, 
    fireDelayValue = 30, 
    currentFireDelay = fireDelayValue;

  int bodyWidth = 50, 
    bodyLength = 40, 
    driverPos = 0, 
    driverWidth = 15, 
    driverLength = 10, 
    glassPos = 5, 
    glassWidth = 20, 
    glassLength = 35, 
    turretPos = 35, 
    turretWidth = 10, 
    turretLength = 30, 
    armXPos = -5, 
    armYPos = 30, 
    armWidth = 25, 
    armLength = 10, 
    legPos = 20, 
    legWidth = 20, 
    legLength = 35, 
    legMoveCap = 10, 
    minimumTurretRot = 100, 
    bulletPerShot = 5;

  int bodyCol = 0xff5F6164, 
    armCol = 0xff4B4E52, 
    legCol = 0xff2B2C2E, 
    glassCol = 0xff799BCE;

  boolean walkAnim = false, 
    legReverse = false, 
    fireReady = true, 
    fireActive = false, 
    fireAltBarrel = false;

  Player(float x_temp, float y_temp) {
    xPos = x_temp;
    yPos = y_temp;
  }

  public void update() {

    legMoveSpeed = moveSpeed;
    legRotation = moveRotation;
    bodyRotation = rotation;

    if (keyUp||keyDown||keyLeft||keyRight) {
      walkAnim = true;
    } else {
      walkAnim = false;
    }

    if (walkAnim) {
      if (legMove > legMoveCap) {
        legReverse = false;
      }
      if (legMove < -legMoveCap) {
        legReverse = true;
      }
      if (legReverse) { 
        legMove += legMoveSpeed;
      } else {
        legMove -= legMoveSpeed;
      }
    }

    pushMatrix();
    translate(xPos, yPos);
    pushMatrix();
    rotate(legRotation);

    fill(legCol);
    rect(legMove, legPos, legLength, legWidth);
    rect(-legMove, -legPos, legLength, legWidth);

    popMatrix();
    pushMatrix();
    rotate(bodyRotation);

    fill(bodyCol);
    rect(0, 0, bodyLength, bodyWidth);
    for (int i = enemyBullets.size()-1; i >= 0; i--) {
      if (dist(enemyBullets.get(i).xPos, enemyBullets.get(i).yPos, xPos, yPos) <= ((bodyWidth/2)+(enemyBulletSize/2))) {
        healthCurrent -= enemyBullets.get(i).damage;
        if (healthCurrent <= 0) {
          healthCurrent = 0;
        }
        enemyBullets.remove(i);
      }
    }

    fill(0);
    ellipse(driverPos, 0, driverLength, driverWidth);

    fill(glassCol, 200);
    rect(glassPos, 0, glassLength, glassWidth);


    float mouseDist = dist(xPos, yPos, mouseX, mouseY);
    if (mouseDist < minimumTurretRot) {
      mouseDist = minimumTurretRot;
    } 
    turretRotation = atan(mouseDist/turretPos);

    fill(0xff7E8186);
    pushMatrix();
    translate(0, turretPos);
    rotate(turretRotation);

    rect(0, 0, turretWidth, turretLength);

    popMatrix();
    pushMatrix();
    translate(0, -turretPos);
    rotate(-turretRotation);

    rect(0, 0, turretWidth, turretLength);

    popMatrix();

    fill(armCol);
    rect(armXPos, armYPos, armLength, armWidth);
    rect(armXPos, -armYPos, armLength, armWidth);

    popMatrix();
    popMatrix();

    if (!fireReady) {
      currentFireDelay--;
      if (currentFireDelay == 0) {
        fireReady = true;
        currentFireDelay = fireDelayValue;
      }
    }

    if (fireReady && fireActive) {
      for (int i = 0; i < bulletPerShot; i++) {
        playerBullets.add(new PlayerBullet(xPosPlayer, yPosPlayer, rotation, player.turretRotation, fireAltBarrel));
      }
      explosions.add(new Explosion(xPosPlayer, yPosPlayer, rotation, false, 0, false, fireAltBarrel));
      fireAltBarrel = !fireAltBarrel;
      fireReady = false;
    }
  }
}
class PlayerBullet {

  float xPos, 
    yPos, 
    bodyRot, 
    dirDeviation = radians(random(-5, 5)), 
    turretRot, 
    distanceFlown, 
    speed = random(9, 11), 
    damage = random(5, 10);

  int size = 5;

  boolean fireAlt;

  PlayerBullet(float x_temp, float y_temp, float rot_temp, float turretRot_temp, boolean fireAlt_temp) {
    xPos = x_temp;
    yPos = y_temp;
    bodyRot = rot_temp;
    turretRot = turretRot_temp;
    fireAlt = fireAlt_temp;

    if (fireAlt) {
      xPos += (player.turretPos * sin(bodyRot)) + ((player.turretLength/2) * cos(bodyRot));
      yPos -= (player.turretPos * cos(bodyRot)) - ((player.turretLength/2) * sin(bodyRot));
    } else {
      xPos -= (player.turretPos * sin(bodyRot)) - ((player.turretLength/2) * cos(bodyRot));
      yPos += (player.turretPos * cos(bodyRot)) + ((player.turretLength/2) * sin(bodyRot));
    }
  }

  public void update() {

    distanceFlown += speed;
    xPos += cos(bodyRot+dirDeviation) * speed;
    yPos += sin(bodyRot+dirDeviation) * speed;

    if (fireAlt) {
      xPos -= sin(bodyRot) * (HALF_PI-turretRot) * speed;
      yPos += cos(bodyRot) * (HALF_PI-turretRot) * speed;
    } else {
      xPos += sin(bodyRot) * (HALF_PI-turretRot) * speed;
      yPos -= cos(bodyRot) * (HALF_PI-turretRot) * speed;
    }

    xPos += areaXPosVector;
    yPos += areaYPosVector;

    pushMatrix();
    translate(xPos, yPos);

    fill(0, 150);
    ellipse(0, 0, size, size);
    popMatrix();
  }
}
class UserInterface {

  float xPosL = 0, 
    yPosB = height, 
    xPosR = width, 
    healthbarFill;

  int healthbarX = 60, 
    healthbarY = -120, 
    healthbarWidth = 40, 
    healthbarHeight = 100, 
    scoreX = -80, 
    scoreY = -60,
    enemyUIIconYOffset = 30,
    widthElem1 = 200, 
    heightElem1 = 40, 
    widthElem2 = 40, 
    heightElem2 = 140, 
    yPosElem3 = -45, 
    widthElem3 = 130, 
    heightElem3 = 200, 
    rotElem3 = -60;

  UserInterface() {
  }

  public void update() {
    rectMode(CORNER);
    pushMatrix();
    translate(xPosL, yPosB);

    pushMatrix();
    rotate(radians(rotElem3));
    fill(player.glassCol, 200);
    rect(0, yPosElem3, widthElem3, heightElem3);
    popMatrix();

    fill(player.bodyCol);
    rect(0, -heightElem2, widthElem2, heightElem2);
    fill(player.armCol);
    rect(0, -heightElem1, widthElem1, heightElem1);

    healthbarFill = healthbarHeight*(player.healthCurrent/player.healthMax);
    fill(player.legCol);
    rect(healthbarX, healthbarY, healthbarWidth, healthbarHeight);
    fill(50, 255, 50);
    rect(healthbarX, healthbarY+(player.healthMax-healthbarFill), healthbarWidth, healthbarFill);

    popMatrix();
    pushMatrix();
    translate(xPosR, yPosB);

    pushMatrix();
    rotate(radians(-rotElem3));
    fill(player.glassCol, 200);
    rect(0, yPosElem3, -widthElem3, heightElem3);
    popMatrix();

    fill(player.bodyCol);
    rect(0, -heightElem2, -widthElem2, heightElem2);
    fill(player.armCol);
    rect(0, -heightElem1, -widthElem1, heightElem1);

    fill(player.legCol);
    text(score, scoreX, scoreY);

    fill(enemyBulletFillCol);
    stroke(enemyBulletStrokeCol);
    strokeWeight(enemyBulletStrokeSize);
    ellipse(scoreX, scoreY + enemyUIIconYOffset, enemyBulletSize, enemyBulletSize);
    noStroke();

    popMatrix();
    rectMode(CENTER);
  }
}
class Wall {

  int xPos, 
    yPos, 
    w = 30, 
    lMulti = (int)random(2, 15), 
    l = w * lMulti, 
    areaNumber;

  float wallRotation = random(TWO_PI), 
    transXPos, 
    transYPos;

  Wall (int x_temp, int y_temp, int number_temp) {
    xPos = x_temp;
    yPos = y_temp;
    areaNumber = number_temp;
  }

  public void update() {

    pushMatrix();
    translate(-areaXPos+xPos, -areaYPos+yPos);

    /*fill(255, 0, 0);
     for (int j = 0; j <= lMulti; j++) {
     ellipse(((w/2) * j * sin(-wallRotation)), ((w/2)* j * cos(wallRotation)), w, w);
     ellipse(((w/2) * -j * sin(-wallRotation)), ((w/2)* -j * cos(wallRotation)), w, w);
     }*/

    rotate(wallRotation);



    fill(0xff816331);
    rect(0, 0, w, l);
    for (int j = 0; j <= lMulti; j++) {
      transXPos = ((w/2) * j * sin(-wallRotation));
      transYPos = ((w/2) * j * cos(wallRotation));
      for (int i = playerBullets.size()-1; i >= 0; i--) {
        if (dist(playerBullets.get(i).xPos, playerBullets.get(i).yPos, -areaXPos+xPos+transXPos, -areaYPos+yPos+transYPos) <= ((w/2)+(playerBullets.get(i).size/2)) || dist(playerBullets.get(i).xPos, playerBullets.get(i).yPos, -areaXPos+xPos-transXPos, -areaYPos+yPos-transYPos) <= ((w/2)+(playerBullets.get(i).size/2))) {
          if (dist(playerBullets.get(i).xPos, playerBullets.get(i).yPos, -areaXPos+xPos, -areaYPos+yPos) <= ((l/2)+(playerBullets.get(i).size/2))) {
            playerBullets.remove(i);
          }
        }
      }
      for (int i = enemyBullets.size()-1; i >= 0; i--) {
        if (dist(enemyBullets.get(i).xPos, enemyBullets.get(i).yPos, -areaXPos+xPos+transXPos, -areaYPos+yPos+transYPos) <= ((w/2)+(enemyBulletSize/2)) || dist(enemyBullets.get(i).xPos, enemyBullets.get(i).yPos, -areaXPos+xPos-transXPos, -areaYPos+yPos-transYPos) <= ((w/2)+(enemyBulletSize/2))) {
          if (dist(enemyBullets.get(i).xPos, enemyBullets.get(i).yPos, -areaXPos+xPos, -areaYPos+yPos) <= ((l/2)+(enemyBulletSize/2))) {
            enemyBullets.remove(i);
          }
        }
      }
    }
    popMatrix();
  }
}
  public void settings() {  fullScreen();  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Sem_1_Exam" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

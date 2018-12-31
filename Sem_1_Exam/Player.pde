class Player {

  float xPos, 
    yPos, 
    healthMax = 100, 
    healthCurrent = healthMax, 
    bodyRotation, 
    legMove = 0, 
    legMoveSpeed, 
    legRotation,
    turretRotation;

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
    minimumTurretRot = 100;

  boolean walkAnim = false, 
    legReverse = false;

  Player(float x_temp, float y_temp) {
    xPos = x_temp;
    yPos = y_temp;
  }

  void update() {

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

    fill(#2B2C2E);
    rect(legMove, legPos, legLength, legWidth);
    rect(-legMove, -legPos, legLength, legWidth);

    popMatrix();
    pushMatrix();
    rotate(bodyRotation);

    fill(#5F6164);
    rect(0, 0, bodyLength, bodyWidth);
    for (int i = enemyBullets.size()-1; i >= 0; i--) {
      if (dist(enemyBullets.get(i).xPos, enemyBullets.get(i).yPos, xPos, yPos) <= ((bodyWidth/2)+(enemyBullets.get(i).size/2))) {
        healthCurrent -= enemyBullets.get(i).damage;
        enemyBullets.remove(i);
      }
    }

    fill(0);
    ellipse(driverPos, 0, driverLength, driverWidth);

    fill(#799BCE, 200);
    rect(glassPos, 0, glassLength, glassWidth);


    float mouseDist = dist(xPos, yPos, mouseX, mouseY);
    if (mouseDist < minimumTurretRot) {
      mouseDist = minimumTurretRot;
    } 
    turretRotation = atan(mouseDist/turretPos);
    
    fill(#7E8186);
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

    fill(#4B4E52);
    rect(armXPos, armYPos, armLength, armWidth);
    rect(armXPos, -armYPos, armLength, armWidth);

    popMatrix();
    popMatrix();
  }
}
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

  color bodyCol = #5F6164,
  armCol = #4B4E52,
  legCol = #2B2C2E,
  glassCol = #799BCE;

  boolean walkAnim = false, 
    legReverse = false, 
    fireReady = true, 
    fireActive = false, 
    fireAltBarrel = false;

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
        if(healthCurrent <= 0){
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
      fireAltBarrel = !fireAltBarrel;
      fireReady = false;
    }
  }
}

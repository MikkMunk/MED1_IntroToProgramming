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
    glassAlpha = 200, 
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
    lightX = 13, 
    lightY = 17, 
    lightSize = 5, 
    minimumTurretRot = 100, 
    bulletPerShot = 5;

  color bodyCol = #5F6164, 
    armCol = #4B4E52, 
    legCol = #2B2C2E,
    turretCol = #7E8186, 
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
    translate(xPos, yPos); //translate to find center point of player character.
    pushMatrix();
    rotate(legRotation); //New matrix layer for leg rotation, since they move independent from the rest of the object.

    fill(legCol);
    rect(legMove, legPos, legLength, legWidth);
    rect(-legMove, -legPos, legLength, legWidth);

    popMatrix();
    pushMatrix();

    rotate(bodyRotation); //pop and push for new matrix that is not affected by the previous, this is for the other parts of the object.

    fill(bodyCol);
    rect(0, 0, bodyLength, bodyWidth);
    for (int i = enemyBullets.size()-1; i >= 0; i--) { //Check all enemy bullets and take damage if the come too close.
      if (dist(enemyBullets.get(i).xPos, enemyBullets.get(i).yPos, xPos, yPos) <= ((bodyWidth/2)+(enemyBulletSize/2))) {
        if (timerCurrent > 0) {
          healthCurrent -= enemyBullets.get(i).damage;
          playerHitSFX.play();
          if (healthCurrent <= 0) {
            healthCurrent = 0;
          }
        }
        enemyBullets.remove(i);
      }
    }

    fill(0);
    ellipse(driverPos, 0, driverLength, driverWidth); //Create visuals for player entity.

    fill(glassCol, glassAlpha);
    rect(glassPos, 0, glassLength, glassWidth);

    fill(ui.startColValue + ui.reCol, 255 - ui.reCol, ui.startColValue); //Add two lights that show health levels by using the color of the health bar.
    ellipse(lightX, lightY, lightSize, lightSize);
    ellipse(lightX, -lightY, lightSize, lightSize);

    float mouseDist = dist(xPos, yPos, mouseX, mouseY); //The upper body is already rotating to face the cursor, but we also want the turrets that are pushed to the sides, to also turn directly towards it.
    if (mouseDist < minimumTurretRot) { //For gameplay purposes we want a minimum value to the rotation.
      mouseDist = minimumTurretRot;
    } 
    turretRotation = atan(mouseDist/turretPos); //We find this rotation by using the distance from the center of the player object to the mouse, and divide it with the distance from same point but to the turrets. This is alse called the inverse tangent.

    fill(turretCol);
    pushMatrix(); //We then add layers and visuals for each turret.
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

    if (!fireReady) { //Same as with towers.
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
      playerFireSFX.play();
      explosions.add(new Explosion(xPosPlayer, yPosPlayer, rotation, false, 0, false, fireAltBarrel));
      fireAltBarrel = !fireAltBarrel;
      fireReady = false;
    }
  }
}

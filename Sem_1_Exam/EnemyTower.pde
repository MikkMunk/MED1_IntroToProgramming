class EnemyTower {

  int xPos, 
    yPos, 
    areaNumber, //Number identical to the area it is in.
    healthAlpha = 100;

  float towerRotation, 
    healthbarFill, 
    size = 40, 
    healthMax = 100, 
    healthCurrent = healthMax, 
    fireDelayValue = 60, //60 because accounting for one second in frames.
    currentFireDelay = fireDelayValue;

  color healthBar = #FF0000, 
    bodyCol1 = #624541, 
    bodyCol2 = #A03023, 
    cannonCol = #D6230F;

  boolean fireReady = true;

  EnemyTower(int x_temp, int y_temp, int number_temp) {
    xPos = x_temp;
    yPos = y_temp;
    areaNumber = number_temp;
  }

  void update() {

    float x = xPosPlayer - (-areaXPos+xPos); //Same as with player rotating towards the mouse, this makes towers rotate towards the player.
    float y = yPosPlayer - (-areaYPos+yPos);
    towerRotation = atan2(y, x);

    pushMatrix();
    translate(-areaXPos+xPos, -areaYPos+yPos); //translate the towers by the negative values of how much the player has moved plus their position gotten during construction in the area.

    if (healthCurrent < healthMax) {
      healthbarFill = size*(healthCurrent/healthMax);
      fill(healthBar, healthAlpha); 
      rect(0, -size, healthbarFill, size/10); //healthbar is added before rotation, so it stays above the tower. The width is based on the percentage of health it has left calculated right before.
    }

    rotate(towerRotation);

    fill(bodyCol1);
    ellipse(0, 0, size, size);
    for (int i = playerBullets.size()-1; i >= 0; i--) { //Each tower checks to see if a player bullet hits them, and if so, takes damage, plays sound and removes the hitting bullet.
      if (dist(playerBullets.get(i).xPos, playerBullets.get(i).yPos, -areaXPos+xPos, -areaYPos+yPos) <= ((size/2)+(playerBullets.get(i).size/2))) {
        healthCurrent -= playerBullets.get(i).damage;
        towerHitSFX.play();
        playerBullets.remove(i);
      }
    }

    fill(cannonCol);
    rect((size/2), 0, size, size/3);

    fill(bodyCol2);
    ellipse(0, 0, size/2, size/2);

    popMatrix();

    if (!fireReady) { //If fire is not ready
      currentFireDelay--; //subtract per frame
      if (currentFireDelay <= 0) { //when it hits 0
        fireReady = true; //make it true
        currentFireDelay = fireDelayValue * random(0.8, 1.2); //and set the next delay to the standard delay value multiplied by a random number for gameplay purposes.
      }
    }

    if (fireReady && timerCurrent > 0 && player.healthCurrent > 0 && dist(xPosPlayer, yPosPlayer, -areaXPos+xPos, -areaYPos+yPos) < enemyInteractionDistance) { //If game is running, tower is ready to shoot and player is within range,
      enemyBullets.add(new EnemyBullet(-areaXPos+xPos, -areaYPos+yPos, towerRotation, size)); //create bullet
      towerFireSFX.play(); //play sound
      explosions.add(new Explosion(-areaXPos+xPos, -areaYPos+yPos, towerRotation, true, size, false, false)); //add explosion visuals
      fireReady = false; //set fire state to false.
    }
  }
}

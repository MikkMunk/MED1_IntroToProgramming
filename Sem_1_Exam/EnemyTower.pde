class EnemyTower {

  int xPos, 
    yPos, 
    areaNumber;

  float towerRotation, 
    healthbarFill, 
    size = 40, 
    healthMax = 100, 
    healthCurrent = healthMax;

  boolean fireReady = true;

  EnemyTower(int x_temp, int y_temp, int number_temp) {
    xPos = x_temp;
    yPos = y_temp;
    areaNumber = number_temp;
  }

  void update() {
    pushMatrix();
    translate(-areaXPos, -areaYPos);

    float x = xPosPlayer - (-areaXPos+xPos);
    float y = yPosPlayer - (-areaYPos+yPos);
    towerRotation = atan2(y, x);

    pushMatrix();
    translate(xPos, yPos);

    healthbarFill = size*(healthCurrent/healthMax);
    fill(255, 0, 0, 100);
    rect(0, -size, healthbarFill, size/10);

    rotate(towerRotation);

    fill(#624541);
    ellipse(0, 0, size, size);
    for (int i = playerBullets.size()-1; i >= 0; i--) {
      if (dist(playerBullets.get(i).xPos, playerBullets.get(i).yPos, -areaXPos+xPos, -areaYPos+yPos) <= ((size/2)+(playerBullets.get(i).size/2))) {
        healthCurrent -= playerBullets.get(i).damage;
        playerBullets.remove(i);
      }
    }

    fill(#A03023);
    rect((size/2), 0, size, size/3);

    fill(#D6230F);
    ellipse(0, 0, size/2, size/2);

    popMatrix();
    popMatrix();

    if (fireReady && dist(xPosPlayer, yPosPlayer, -areaXPos+xPos, -areaYPos+yPos) < width/2) {
      enemyBullets.add(new EnemyBullet(-areaXPos+xPos, -areaYPos+yPos, towerRotation, size));
    }
  }
}

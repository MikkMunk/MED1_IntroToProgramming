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
    randomXScale = random(.8, 1.2), 
    randomYScale = random(.8, 1.2), 
    enemyDeathScale = 1, 
    centerScale = .5;

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

  void update() {
    alpha -= fadeSpeed;
    xPos += areaXPosVector;
    yPos += areaYPosVector;

    pushMatrix();
    translate(xPos, yPos);
    rotate(radians(randomRotation));

    fill(#FF3700, alpha);
    beginShape();
    for (int i = 0; i < x.length; i++) {
      vertex(x[i]*randomXScale*enemyDeathScale, y[i]*randomYScale*enemyDeathScale);
    }
    endShape(CLOSE);

    fill(#FFE200, alpha);
    beginShape();
    for (int i = 0; i < x.length; i++) {
      vertex(x[i]*randomXScale*centerScale*enemyDeathScale, y[i]*randomYScale*centerScale*enemyDeathScale);
    }
    endShape(CLOSE);

    popMatrix();
  }
}

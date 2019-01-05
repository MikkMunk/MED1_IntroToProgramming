class Explosion {

  int fadeSpeed = 30;

  int[] x = {6, 6, 10, 8, 19, 8, 16, 4, 3, -1, -7, -7, -13, -9, -13, -10, -19, -6, -5, -2}, //I used the tool on this address: https://www.khanacademy.org/math/basic-geo/basic-geo-coord-plane/polygons-in-the-coordinate-plane/e/drawing-polygons
    y = {-19, -6, -7, -4, 0, 4, 12, 8, 14, 10, 19, 8, 9, 2, 0, -1, -7, -5, -11, -7}; //to make a visual shape for the explosion graphic, and took the coordinates from my drawing.

  float xPos, 
    yPos, 
    rot, 
    towerSize, 
    alpha = 255, 
    randomRotation = random(360), 
    randomXScale = random(.8, 1.2), 
    randomYScale = random(.8, 1.2), 
    enemyDeathScale = 1, 
    towerDeathScale = 4, 
    centerScale = .5;

  color outerExploCol = #FF3700, 
    innerExploCol = #FFE200;

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

    if (!enemyFire && !enemyDeath) { //The explosion has a few differences based on what type of situation spawned it. If it is from the player weapon fire, they will spawn at the turrets tip location.
      if (playerFireAlt) {
        xPos += (player.turretPos * sin(rot)) + ((player.turretLength/2) * cos(rot));
        yPos -= (player.turretPos * cos(rot)) - ((player.turretLength/2) * sin(rot));
      } else {
        xPos -= (player.turretPos * sin(rot)) - ((player.turretLength/2) * cos(rot));
        yPos += (player.turretPos * cos(rot)) + ((player.turretLength/2) * sin(rot));
      }
    } else if (enemyFire) { //If it is from enemies firing it adds the tower size values and uses another way to calculate its position.
      towerSize = towerSize_temp;
      xPos += (towerSize * cos(rot));
      yPos += (towerSize * sin(rot));
    } else if (enemyDeath) { //if it is from an enemy dying it simply adds a scale to size.
      enemyDeathScale = towerDeathScale;
    }
  }

  void update() {
    alpha -= fadeSpeed; //Makes the object visually fade over time. When this hits 0 the object is removed.
    xPos += areaXPosVector;
    yPos += areaYPosVector;

    pushMatrix();
    translate(xPos, yPos);
    rotate(radians(randomRotation));

    fill(outerExploCol, alpha);
    beginShape();
    for (int i = 0; i < x.length; i++) { //red outer shape of the explosion
      vertex(x[i]*randomXScale*enemyDeathScale, y[i]*randomYScale*enemyDeathScale);
    }
    endShape(CLOSE);

    fill(innerExploCol, alpha);
    beginShape();
    for (int i = 0; i < x.length; i++) { //yellow inner shape. They both use the same position values 
      vertex(x[i]*randomXScale*centerScale*enemyDeathScale, y[i]*randomYScale*centerScale*enemyDeathScale);
    }
    endShape(CLOSE);

    popMatrix();
  }
}

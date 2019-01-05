class PlayerBullet {

  float xPos, 
    yPos, 
    bodyRot, 
    dirDeviation = radians(random(-5, 5)), 
    turretRot, 
    distanceFlown, 
    speed = random(9, 11), 
    damage = random(5, 10);

  int size = 5, 
    alpha = 150;

  boolean fireAlt;

  PlayerBullet(float x_temp, float y_temp, float rot_temp, float turretRot_temp, boolean fireAlt_temp) {
    xPos = x_temp;
    yPos = y_temp;
    bodyRot = rot_temp;
    turretRot = turretRot_temp;
    fireAlt = fireAlt_temp;

    if (fireAlt) { //Construct the bullets at the right positions by the turrets.
      xPos += (player.turretPos * sin(bodyRot)) + ((player.turretLength/2) * cos(bodyRot));
      yPos -= (player.turretPos * cos(bodyRot)) - ((player.turretLength/2) * sin(bodyRot));
    } else {
      xPos -= (player.turretPos * sin(bodyRot)) - ((player.turretLength/2) * cos(bodyRot));
      yPos += (player.turretPos * cos(bodyRot)) + ((player.turretLength/2) * sin(bodyRot));
    }
  }

  void update() { //Same as enemy bullets.

    distanceFlown += speed;
    xPos += cos(bodyRot+dirDeviation) * speed; //Adding deviation for randomized spread. Gameplay purposes.
    yPos += sin(bodyRot+dirDeviation) * speed;
    xPos += areaXPosVector;
    yPos += areaYPosVector;

    if (fireAlt) {
      xPos -= sin(bodyRot) * (HALF_PI-turretRot) * speed;
      yPos += cos(bodyRot) * (HALF_PI-turretRot) * speed;
    } else {
      xPos += sin(bodyRot) * (HALF_PI-turretRot) * speed;
      yPos -= cos(bodyRot) * (HALF_PI-turretRot) * speed;
    }

    fill(0, alpha);
    ellipse(xPos, yPos, size, size);
  }
}

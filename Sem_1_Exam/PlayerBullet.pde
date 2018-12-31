class PlayerBullet {

  float xPos, 
    yPos, 
    bodyRot, 
    turretRot, 
    distanceFlown, 
    damage = 10;

  int size = 5, 
    speed = 10;

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

  void update() {

    distanceFlown += speed;
    xPos += cos(bodyRot) * speed;
    yPos += sin(bodyRot) * speed;

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

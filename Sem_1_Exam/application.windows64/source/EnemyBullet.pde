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

  void update() {

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

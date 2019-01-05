class EnemyBullet {

  float xPos, 
    yPos, 
    bulletDir, 
    dirDeviation = radians(random(-10, 10)), 
    towerSize, 
    distanceFlown, 
    damage = 5;

  int speed = 10, 
    alpha = 200;

  EnemyBullet(float x_temp, float y_temp, float rot_temp, float towerSize_temp) {
    xPos = x_temp;
    yPos = y_temp;
    towerSize = towerSize_temp;
    bulletDir = rot_temp;

    xPos += (towerSize * cos(bulletDir)); //Bullet are constructed with respect to the rotation and size of the towers so that they appear coming out of its cannon.
    yPos += (towerSize * sin(bulletDir));
  }

  void update() {

    distanceFlown += speed; //This is only used to remove the bullet after it has moved a distance.
    xPos = (xPos + cos(bulletDir+dirDeviation) * speed); //Same as with construction, the bullets move in the right direction. I have added a randomized deviation for gameplay purposes.
    yPos = (yPos + sin(bulletDir+dirDeviation) * speed);
    xPos += areaXPosVector; //Add areaPosVectors so the bullets also move with respect to the player moving around.
    yPos += areaYPosVector;

    fill(enemyBulletFillCol, alpha);
    stroke(enemyBulletStrokeCol, alpha);
    strokeWeight(enemyBulletStrokeSize);
    ellipse(xPos, yPos, enemyBulletSize, enemyBulletSize);
    noStroke();
  }
}

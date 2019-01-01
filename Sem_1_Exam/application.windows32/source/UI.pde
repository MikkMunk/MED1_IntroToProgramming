class UserInterface {

  float xPosL = 0, 
    yPosB = height, 
    xPosR = width, 
    healthbarFill;

  int healthbarX = 60, 
    healthbarY = -120, 
    healthbarWidth = 40, 
    healthbarHeight = 100, 
    scoreX = -80, 
    scoreY = -60,
    enemyUIIconYOffset = 30,
    widthElem1 = 200, 
    heightElem1 = 40, 
    widthElem2 = 40, 
    heightElem2 = 140, 
    yPosElem3 = -45, 
    widthElem3 = 130, 
    heightElem3 = 200, 
    rotElem3 = -60;

  UserInterface() {
  }

  void update() {
    rectMode(CORNER);
    pushMatrix();
    translate(xPosL, yPosB);

    pushMatrix();
    rotate(radians(rotElem3));
    fill(player.glassCol, 200);
    rect(0, yPosElem3, widthElem3, heightElem3);
    popMatrix();

    fill(player.bodyCol);
    rect(0, -heightElem2, widthElem2, heightElem2);
    fill(player.armCol);
    rect(0, -heightElem1, widthElem1, heightElem1);

    healthbarFill = healthbarHeight*(player.healthCurrent/player.healthMax);
    fill(player.legCol);
    rect(healthbarX, healthbarY, healthbarWidth, healthbarHeight);
    fill(50, 255, 50);
    rect(healthbarX, healthbarY+(player.healthMax-healthbarFill), healthbarWidth, healthbarFill);

    popMatrix();
    pushMatrix();
    translate(xPosR, yPosB);

    pushMatrix();
    rotate(radians(-rotElem3));
    fill(player.glassCol, 200);
    rect(0, yPosElem3, -widthElem3, heightElem3);
    popMatrix();

    fill(player.bodyCol);
    rect(0, -heightElem2, -widthElem2, heightElem2);
    fill(player.armCol);
    rect(0, -heightElem1, -widthElem1, heightElem1);

    fill(player.legCol);
    text(score, scoreX, scoreY);

    fill(enemyBulletFillCol);
    stroke(enemyBulletStrokeCol);
    strokeWeight(enemyBulletStrokeSize);
    ellipse(scoreX, scoreY + enemyUIIconYOffset, enemyBulletSize, enemyBulletSize);
    noStroke();

    popMatrix();
    rectMode(CENTER);
  }
}

class UserInterface {

  float xPosL = 0, 
    yPosB = height, 
    xPosR = width, 
    healthbarFill;

  int healthbarX = 60, 
    healthbarY = -120, 
    healthbarWidth = 40, 
    healthbarHeight = 100, 
    menuYOffset = -150, 
    menuYDist = 30, 
    scoreX = -120, 
    scoreY = -60, 
    timerX = -75, 
    timerY = -70, 
    timerSize = 50, 
    timerDia = timerSize/2, 
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
    textSize(30);
    text(score, scoreX, scoreY);

    fill(enemyBulletFillCol);
    stroke(enemyBulletStrokeCol);
    strokeWeight(enemyBulletStrokeSize);
    ellipse(scoreX, scoreY + enemyUIIconYOffset, enemyBulletSize, enemyBulletSize);
    noStroke();

    fill(255, 150);
    ellipse(timerX, timerY, timerSize, timerSize);

    strokeWeight(2);
    stroke(player.armCol);
    line(timerX, timerY, timerX, timerY-timerDia);

    stroke(player.bodyCol);
    line(timerX+timerDia, timerY, timerX+timerDia-timerDia/3, timerY);
    line(timerX-timerDia, timerY, timerX-timerDia+timerDia/3, timerY);
    line(timerX, timerY+timerDia, timerX, timerY+timerDia-timerDia/3);

    float tic = map(timerMax-timerCurrent, 0, timerMax, 0, TWO_PI) - HALF_PI;
    if (timerCurrent > timerMax/4) {
      stroke(player.legCol);
    } else {
      stroke(enemyBulletFillCol);
    }
    strokeWeight(3);
    line(timerX, timerY, timerX + cos(tic) * timerDia, timerY + sin(tic) * timerDia);
    noStroke();

    popMatrix();
    rectMode(CENTER);

    if (gamePaused) {
      fill(player.legCol);
      textSize(30);
      text("Game starts when you move", xPosPlayer, yPosPlayer+menuYOffset);
      textSize(16);
      text("Destroy Turrets within the time limit and stay alive", xPosPlayer, yPosPlayer+menuYOffset+menuYDist);
      textSize(12);
      text("Controls: Move with WASD or arrows, aim and fire with mouse, restart with R", xPosPlayer, yPosPlayer+menuYOffset+menuYDist*2);
    }

    if (timerCurrent == 0 || player.healthCurrent == 0) {
      fill(player.legCol);
      textSize(40);
      text("Game Over", xPosPlayer, yPosPlayer+menuYOffset);
      textSize(20);
      text("Final Score: ", xPosPlayer, yPosPlayer+menuYOffset+menuYDist);
      textSize(30);
      text(score, xPosPlayer, yPosPlayer+menuYOffset+menuYDist*2.5);
    }
  }
}

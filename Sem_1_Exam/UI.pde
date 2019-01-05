class UserInterface {

  float xPosL = 0, 
    yPosB = height, 
    xPosR = width, 
    healthbarFill,
    startColValue = 50,
    reCol;

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
    
    color timerAlpha = 150;

  UserInterface() {
  }

  void update() {
    rectMode(CORNER); //Switching rectMode for ease of positioning.
    pushMatrix();
    translate(xPosL, yPosB); //First we translate to the left corner to place elements in relation to this as a center point.

    pushMatrix();
    rotate(radians(rotElem3));
    fill(player.glassCol, 200);
    rect(0, yPosElem3, widthElem3, heightElem3);
    popMatrix();

    fill(player.bodyCol);
    rect(0, -heightElem2, widthElem2, heightElem2);
    fill(player.armCol);
    rect(0, -heightElem1, widthElem1, heightElem1);

    healthbarFill = healthbarHeight*(player.healthCurrent/player.healthMax); //Finding health percentage to create rectangles with the proper sizes to show current health.
    fill(player.legCol);
    rect(healthbarX, healthbarY, healthbarWidth, healthbarHeight);
    reCol = map(player.healthMax-player.healthCurrent, 0, player.healthMax, startColValue, 255 - startColValue); //Also mapping reCol to be same percentage between 50 and 205, as missing health is between 0 and max health
    fill(startColValue + reCol, 255 - reCol, startColValue); //when using this in fill by both adding the value to one perimeter, while subtracting it from another, the colored objects will be able to fade between chosen colors.
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

    fill(255, timerAlpha); //Creating timer to show remaining time. 
    ellipse(timerX, timerY, timerSize, timerSize);

    strokeWeight(2);
    stroke(player.armCol);
    line(timerX, timerY, timerX, timerY-timerDia);

    stroke(player.bodyCol);
    line(timerX+timerDia, timerY, timerX+timerDia-timerDia/3, timerY);
    line(timerX-timerDia, timerY, timerX-timerDia+timerDia/3, timerY);
    line(timerX, timerY+timerDia, timerX, timerY+timerDia-timerDia/3);

    float tic = map(timerMax-timerCurrent, 0, timerMax, 0, TWO_PI) - HALF_PI; //Mapping tic to have the finger show time remaining on the timer, in relation to time remaining out of max, and PI*2.
    if (timerCurrent > timerMax/4) { //If more than a fourth of the time is remaining color it same as player legs
      stroke(player.legCol);
    } else { //If not color it red as enemy bullets.
      stroke(enemyBulletFillCol);
    }
    strokeWeight(3);
    line(timerX, timerY, timerX + cos(tic) * timerDia, timerY + sin(tic) * timerDia); //Add timer finger with one end in center of the timer, and the other at the edge in relation to what angle tic is between 0 and PI*2. 
    noStroke();

    popMatrix();
    rectMode(CENTER);

    if (gamePaused) { //Show text in certain situations.
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
      finalScore = score * (1 + ((player.healthCurrent / player.healthMax) / 2)); //Final score is based on tower kills multiplied by up to 1.5 based on remaining health.
      text(round(finalScore), xPosPlayer, yPosPlayer + menuYOffset + menuYDist * 2.5);
    }
  }
}

class Area {

  int towerAmount = (int)random(2, 4);

  int[] towerX = new int[towerAmount], 
    towerY = new int[towerAmount];

  int size = 20, 
    strokeSize = size/4, 
    number;

  float xPos, 
    yPos;

  Area(float x_temp, float y_temp, int number_temp) {
    xPos = x_temp;
    yPos = y_temp;
    number = number_temp;
    
    for (int i = 0; i < towerAmount; i++) {
      towerX[i] = (int)xPos + (int)random(-width/2, width/2);
    }
    for (int i = 0; i < towerAmount; i++) {
      towerY[i] = (int)yPos + (int)random(-height/2, height/2);
    }
    if (number != 4) {
      for (int i = 0; i < towerAmount; i++) {
        enemyTowers.add(new EnemyTower(towerX[i], towerY[i], number));
      }
    }
  }

  void update() {
    pushMatrix();
    translate(-areaXPos, -areaYPos);

    fill(#EAC766);
    rect(xPos, yPos, width, height);

    stroke(#D1AA1E, 150);
    strokeWeight(strokeSize);
    ellipse(xPos, yPos, size, size);
    noStroke();

    fill(0);
    //text(number, xPos, yPos);

    popMatrix();
  }
}

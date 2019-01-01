class Area {

  int towerAmount = (int)random(2, 5), 
    wallAmount = (int)random(2, 10);

  int[] towerX = new int[towerAmount], 
    towerY = new int[towerAmount], 
    wallX = new int[wallAmount], 
    wallY = new int[wallAmount];

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

    for (int i = 0; i < wallAmount; i++) {
      wallX[i] = (int)xPos + (int)random(-width/2, width/2);
    }
    for (int i = 0; i < wallAmount; i++) {
      wallY[i] = (int)yPos + (int)random(-height/2, height/2);
    }
    for (int i = 0; i < wallAmount; i++) {
      walls.add(new Wall(wallX[i], wallY[i], number));
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

    popMatrix();
  }
}

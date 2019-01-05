class Area {

  int towerAmount = (int)random(2, 5), //Random values to decide how many towers and walls are in each individual area.
    wallAmount = (int)random(3, 15);

  int[] towerX = new int[towerAmount], //Create arrays for positions of towers and walls.
    towerY = new int[towerAmount], 
    wallX = new int[wallAmount], 
    wallY = new int[wallAmount];

  int size = 20, //Size used to create spawn point ellipse.
    strokeSize = size/4, 
    number, //Number of the area, this is used to keep the area linked with the towers and walls inside it.
    startingNumber = 4; //The areaNumber of the area the player starts in after each reset.

  float xPos, //Position for the area.
    yPos;

  Area(float x_temp, float y_temp, int number_temp) {
    xPos = x_temp;
    yPos = y_temp;
    number = number_temp;

    for (int i = 0; i < towerAmount; i++) { //Randomize the array position values of towers and walls. The values will remain within the borders of the area.
      towerX[i] = (int)xPos + (int)random(-width/2, width/2);
    }
    for (int i = 0; i < towerAmount; i++) {
      towerY[i] = (int)yPos + (int)random(-height/2, height/2);
    }
    for (int i = 0; i < wallAmount; i++) {
      wallX[i] = (int)xPos + (int)random(-width/2, width/2);
    }
    for (int i = 0; i < wallAmount; i++) {
      wallY[i] = (int)yPos + (int)random(-height/2, height/2);
    }
    if (number != startingNumber) { //If it is not the starting area, create towers.
      for (int i = 0; i < towerAmount; i++) {
        enemyTowers.add(new EnemyTower(towerX[i], towerY[i], number));
      }
      for (int i = 0; i < wallAmount; i++) {
        walls.add(new Wall(wallX[i], wallY[i], number));
      }
    }
  }

  void update() {
    pushMatrix(); //Add a layer of translation and rotation of elements.
    translate(-areaXPos, -areaYPos); //Move areas by the area position amounts. With player movement these values are the ones changing, not the player entity itself. It fakes movement over terrain with an attached camera.

    fill(backgroundCol); //Create background.
    rect(xPos, yPos, width, height);

    if (number == startingNumber) { //Create spawn circle in spawning area.
      stroke(#D1AA1E, 150);
      strokeWeight(strokeSize);
      ellipse(xPos, yPos, size, size);
      noStroke();
    }

    popMatrix(); //Go down a layer of translation and rotation of elements.
  }
}

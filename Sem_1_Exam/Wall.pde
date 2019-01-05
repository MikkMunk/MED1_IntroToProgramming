class Wall {

  int xPos, 
    yPos, 
    w = 30, 
    lMulti = (int)random(2, 15), //Used to indicate length and amount of distance point calculations made per wall.
    l = w * lMulti, 
    areaNumber;

  float wallRotation = random(TWO_PI), 
    transXPos, 
    transYPos;
    
    color wallCol = #816331;

  Wall (int x_temp, int y_temp, int number_temp) {
    xPos = x_temp;
    yPos = y_temp;
    areaNumber = number_temp;
  }

  void update() {

    pushMatrix();
    translate(-areaXPos+xPos, -areaYPos+yPos);

    /*fill(255, 0, 0); //Visuals used to help find calculations.
     for (int j = 0; j <= lMulti; j++) {
     ellipse(((w/2) * j * sin(-wallRotation)), ((w/2)* j * cos(wallRotation)), w, w);
     ellipse(((w/2) * -j * sin(-wallRotation)), ((w/2)* -j * cos(wallRotation)), w, w);
     }*/

    rotate(wallRotation);

    fill(wallCol);
    rect(0, 0, w, l);
    for (int j = 0; j <= lMulti; j++) {
      transXPos = ((w/2) * j * sin(-wallRotation)); //Finds the rotated coordinates for each wall length segment. 
      transYPos = ((w/2) * j * cos(wallRotation));
      for (int i = playerBullets.size()-1; i >= 0; i--) {
        if (dist(playerBullets.get(i).xPos, playerBullets.get(i).yPos, -areaXPos+xPos+transXPos, -areaYPos+yPos+transYPos) <= ((w/2)+(playerBullets.get(i).size/2)) || dist(playerBullets.get(i).xPos, playerBullets.get(i).yPos, -areaXPos+xPos-transXPos, -areaYPos+yPos-transYPos) <= ((w/2)+(playerBullets.get(i).size/2))) { //Checks to see if a bullet is within range of each segment 
          if (dist(playerBullets.get(i).xPos, playerBullets.get(i).yPos, -areaXPos+xPos, -areaYPos+yPos) <= ((l/2)+(playerBullets.get(i).size/2))) { //This check is to smooth the edge checks of the walls 
            playerBullets.remove(i);
          }
        }
      }
      for (int i = enemyBullets.size()-1; i >= 0; i--) {
        if (dist(enemyBullets.get(i).xPos, enemyBullets.get(i).yPos, -areaXPos+xPos+transXPos, -areaYPos+yPos+transYPos) <= ((w/2)+(enemyBulletSize/2)) || dist(enemyBullets.get(i).xPos, enemyBullets.get(i).yPos, -areaXPos+xPos-transXPos, -areaYPos+yPos-transYPos) <= ((w/2)+(enemyBulletSize/2))) {
          if (dist(enemyBullets.get(i).xPos, enemyBullets.get(i).yPos, -areaXPos+xPos, -areaYPos+yPos) <= ((l/2)+(enemyBulletSize/2))) {
            enemyBullets.remove(i);
          }
        }
      }
    }
    popMatrix();
  }
}

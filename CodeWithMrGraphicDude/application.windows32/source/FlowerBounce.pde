ArrayList<Flowerbud> flowers;

int r = 60, 
  timer = 0, 
  timerLimit = 120, 
  col1 = 122, 
  col2 = 122, 
  col3 = 122, 
  colChange = 10, 
  ballRadius = 20, 
  flowerAmount = 30, 
  cornerCounter = 0, 
  counterTimer = 0;

float ballX, 
  ballY;

boolean playerHit = false;

void setup() {
  size(1200, 800);
  background(#08FAEC);
  smooth();

  flowers = new ArrayList<Flowerbud>();
}

void draw()
{
  col1 += (int)random(-colChange, colChange);
  col2 += (int)random(-colChange, colChange);
  col3 += (int)random(-colChange, colChange);

  if (col1 < 0) 
  {
    col1 = 0;
  }

  if (col1 > 255) 
  {
    col1 = 255;
  }

  if (col2 < 0) 
  {
    col2 = 0;
  }

  if (col2 > 255) 
  {
    col2 = 255;
  }

  if (col3 < 0) 
  {
    col3 = 0;
  }

  if (col3 > 255) 
  {
    col3 = 255;
  }

  background(color(col1, col2, col3));
  if (flowers.size() < flowerAmount) {
    flowers.add(new Flowerbud(random(width), random(height), (int)random(5, 12), random(10, 50), (int)random(255), (int)random(255), (int)random(255), (int)random(2), random(-5, 5), random(-5, 5)));
  }

  for (int i = flowers.size()-1; i >= 0; i--) {
    Flowerbud flower = flowers.get(i);
    flower.display();
    if (playerObjectHit(flower.xPos, flower.yPos, flower.radius) == true) {
      ballRadius = 0;
      playerHit = true;
    }
  }

  if (flowers.size() == flowerAmount) {
    timer += 1;
    if (timer == timerLimit) {
      flowers.remove(0);
      timer = 0;
    }
  }

  fill(0, 255, 0);
  ellipse(mouseX, mouseY, ballRadius, ballRadius);
  
  if (playerHit == false) {
    counterTimer += 1;
    textAlign(LEFT, CENTER);
    textSize(20);
    text("Seconds: " + cornerCounter, 10, 30);
  } else {
    textAlign(CENTER, CENTER);
    textSize(200);
    text(cornerCounter, width / 2, height / 2);
  }

  if (counterTimer == 60) {
    cornerCounter += 1;
    counterTimer = 0;
  }
}

class Flowerbud 
{
  float xPos, yPos, radius, xVel, yVel;
  int petalAmount, centerColour, col1, col2, col3, colChange = 10;

  Flowerbud(float x, float y, int n_petals, float r, int petalCol1, int petalCol2, int petalCol3, int centerCol, float xVel_temp, float yVel_temp) 
  {
    xPos = x;
    yPos = y;
    petalAmount = n_petals;
    radius = r;
    col1 = petalCol1;
    col2 = petalCol2;
    col3 = petalCol3;
    centerColour = centerCol;
    xVel = xVel_temp;
    yVel = yVel_temp;
  }

  void display() 
  {
    col1 += (int)random(-colChange, colChange);
    col2 += (int)random(-colChange, colChange);
    col3 += (int)random(-colChange, colChange);

    if (col1 < 0) 
    {
      col1 = 0;
    }

    if (col1 > 255) 
    {
      col1 = 255;
    }

    if (col2 < 0) 
    {
      col2 = 0;
    }

    if (col2 > 255) 
    {
      col2 = 255;
    }

    if (col3 < 0) 
    {
      col3 = 0;
    }

    if (col3 > 255) 
    {
      col3 = 255;
    }

    fill(color(col1, col2, col3));

    if (xPos > width || xPos < 0) 
    {
      xVel *= -1;
    }

    if (yPos > height || yPos < 0) 
    {
      yVel *= -1;
    }

    xPos += xVel;
    yPos += yVel;

    noStroke();
    for (float i = 0; i < PI*2; i += 2 * PI/petalAmount) {
      ballX = xPos + radius*cos(i);
      ballY = yPos + radius*sin(i);
      ellipse(ballX, ballY, radius, radius);
    }
    if (centerColour == 1) {
      fill(255, 255, 0);
    } else {
      fill(255, 0, 0);
    }
    stroke(0);
    ellipse(xPos, yPos, radius*2, radius*2);
  }
}

boolean playerObjectHit(float flowerX, float flowerY, float flowerRad) 
{
  float d = dist(flowerX, flowerY, mouseX, mouseY);

  if (d < ((flowerRad * 1.4) + (ballRadius / 2))) {
    return true;
  } else {
    return false;
  }
}

void mousePressed() {
  if (ballRadius < 20) {
    ballRadius = 20;
    cornerCounter = 0;
    counterTimer = 0;
    playerHit = false;
  }
}

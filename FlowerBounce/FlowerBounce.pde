ArrayList<Flowerbud> flowers;

int r=60;
float ballX;
float ballY;

int flowerAmount = 30;

void setup() {
  size(1200, 800);
  background(#08FAEC);
  smooth();

  flowers = new ArrayList<Flowerbud>();
}

void draw()
{
  background(#08FAEC);
  if (flowers.size() < flowerAmount) {
    flowers.add(new Flowerbud(random(width), random(height), (int)random(3, 12), random(10, 100), color(random(255), random(255), random(255)), (int)random(2), random(-5, 5), random(-5, 5)));
  }

  for (int i = flowers.size()-1; i >= 0; i--) {
    Flowerbud flower = flowers.get(i);
    flower.display();
  }

  if (flowers.size() == flowerAmount) {
    flowers.remove(0);
  }
}

/*void spawnFlower() 
{
  delay(3000);
  flowers.add(new Flowerbud(random(width), random(height), (int)random(3, 12), random(10, 100), color(random(255), random(255), random(255)), (int)random(2), random(-5, 5), random(-5, 5)));
}*/

class Flowerbud 
{
  float xPos, yPos, radius, xVel, yVel;
  int petalAmount, centerColour;
  color petalColour;

  Flowerbud(float x, float y, int n_petals, float r, color petalCol, int centerCol, float xVel_temp, float yVel_temp) 
  {
    xPos = x;
    yPos = y;
    petalAmount = n_petals;
    radius = r;
    petalColour = petalCol;
    centerColour = centerCol;
    xVel = xVel_temp;
    yVel = yVel_temp;
  }

  void display() 
  {
    fill(petalColour);

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
    ellipse(xPos, yPos, radius*1.2, radius*1.2);
  }
}

void mousePressed() 
{
  flowers.add(new Flowerbud(mouseX, mouseY, (int)random(3, 12), random(10, 100), color(random(255), random(255), random(255)), (int)random(2), random(-15, 15), random(-15, 15)));

  flowers.remove(0);
}

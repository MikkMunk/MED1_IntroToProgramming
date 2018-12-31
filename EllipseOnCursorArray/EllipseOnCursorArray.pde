int num = 5;
Particle[] particle = new Particle[num];
int[] x = new int[num];
int[] y = new int[num];
int indexPosition = 0;

void setup() { 
  size(1200, 800);
  noStroke();
  textAlign(CENTER, CENTER);
  background(0);
}

void draw() {
}

//Switch between the examples here
void mousePressed() {
  firstExample();
  //secondExample();
}

void firstExample() {
  background(0);
  // Shift the values to the right
  for (int i = num-1; i > 0; i--) {
    println("x[i] = "+ x[i] +" before");
    println("x[i-1] = "+ x[i-1] +" before");
    x[i] = x[i-1];
    y[i] = y[i-1];
    println("x[i] = "+ x[i] +" after");
    println("x[i-1] = "+ x[i-1] +" after");
  }
  // Add the new values to the beginning of the array
  x[0] = mouseX;
  y[0] = mouseY;
  // Draw the circles
  for (int i = 0; i < num; i++) {
    particle[i] = new Particle(x[i], y[i], 20, i);
    particle[i].update();
  }

  println("x[0] = "+ x[0]);
  println("x[1] = "+ x[1]);
  println("x[2] = "+ x[2]);
  println("x[3] = "+ x[3]);
  println("x[4] = "+ x[4]);
}

void secondExample() {
  background(0);
  x[indexPosition] = mouseX;
  y[indexPosition] = mouseY;
  indexPosition = (indexPosition + 1) % num;
  for (int i = 0; i < num; i++) {
    int pos = (indexPosition + i) % num;
    particle[pos] = new Particle(x[pos], y[pos], 20, pos);
    particle[pos].update();

    //println(pos);
  }
}

//first run
//x[0] = mouseX;
//y[0] = mouseY;
//1 = (indexPosition + 1) % num;
//for (int i = 0; i < num; i++) {
//i = 0;
//int 1 = (1 + 0) % num;
//ellipse(x[1] 0, y[1] 0, 20, 20);

//i = 1;
//int 2 = (1 + 1) % num;
//ellipse(x[2] 0, y[2] 0, 20, 20);

//i = 2;
//int 3 = (1 + 2) % num;
//ellipse(x[3] 0, y[3] 0, 20, 20);

//i = 3;
//int 4 = (1 + 3) % num;
//ellipse(x[4] 0, y[4] 0, 20, 20);

//i = 4;
//int 0 = (1 + 4) % num;
//ellipse(x[0] mouseX, y[0] mouseY, 20, 20);
//}

//second run
//x[0] = mouseX;
//y[0] = mouseY;
//2 = (indexPosition + 1) % num;
//for (int i = 0; i < num; i++) {
//i = 0;
//int 2 = (2 + 0) % num;
//ellipse(x[2] 0, y[2] 0, 20, 20);

//i = 1;
//int 3 = (2 + 1) % num;
//ellipse(x[3] 0, y[3] 0, 20, 20);

//i = 2;
//int 4 = (2 + 2) % num;
//ellipse(x[4] 0, y[4] 0, 20, 20);

//i = 3;
//int 0 = (2 + 3) % num;
//ellipse(x[0] mouseX, y[0] mouseY, 20, 20);

//i = 4;
//int 1 = (2 + 4) % num;
//ellipse(x[1] pre mouseX, x[1] pre mouseY, 20, 20);
//}

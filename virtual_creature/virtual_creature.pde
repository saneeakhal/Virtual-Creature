boolean debug = true;
PVector position, target;
PImage ghostCurrent, candyghost, evilghost, trickortreaters, boo, hauntedhouse;
float margin = 50;

boolean isBothered = false;
int botheredMarkTime = 0;
int botheredTimeout = 3000;
float botheredSpread = 5;

boolean isAlone = false;
int aloneMarkTime = 0;
int aloneTimeout = 4000;
int aloneDuration = 250;

float triggerDistance1 = 100;
float triggerDistance2 = 5;
float movementSpeed = 0.08;

void setup() { 
  size(800, 600, P2D);
  
  position = new PVector(width/2, height/2);
  pickTarget();
  
  
  hauntedhouse = loadImage ("hauntedhouse.jpg");
  candyghost = loadImage("candyghost.png");
  candyghost.resize(candyghost.width/3, candyghost.height/3);
  evilghost = loadImage("evilghost.png");
  evilghost.resize(candyghost.width, candyghost.height);
   boo = loadImage ("boo.png");
   boo.resize(candyghost.width, candyghost.height);
  trickortreaters = loadImage("trickortreater.png");
  trickortreaters.resize(candyghost.width, candyghost.height);
  
  ghostCurrent = boo;
  
  ellipseMode(CENTER);
  rectMode(CENTER);
  imageMode(CENTER);
}

void draw() {
  background(hauntedhouse);
  
  PVector mousePos = new PVector(mouseX, mouseY);
  isBothered = position.dist(mousePos) < triggerDistance1;
  
  if (isBothered) {
    botheredMarkTime = millis();
    ghostCurrent = evilghost;
    position = position.lerp(target, movementSpeed).add(new PVector(random(-botheredSpread, botheredSpread), random(-botheredSpread, botheredSpread)));
    if (position.dist(target) < triggerDistance2) {
      pickTarget();
      cursor();
    }
  } else if (!isBothered && millis() > botheredMarkTime + botheredTimeout) {
    if (!isAlone && millis() > aloneMarkTime + aloneTimeout) {
      isAlone = true;
      cursor();
      aloneMarkTime = millis();
    } else if (isAlone && millis() > aloneMarkTime + aloneDuration) {
      isAlone = false;
      cursor();
    }
    } if (isBothered){
      ghostCurrent = evilghost;
     } else if (!isBothered && millis() > botheredMarkTime + botheredTimeout/6) {
    ghostCurrent = boo;
    cursor();
  }
    if (mouseButton == LEFT) {
      ghostCurrent = candyghost;
      position = position.lerp(mousePos, 0.05);
      
      image (trickortreaters, mouseX, mouseY, 128, 128);
      noCursor();
     
      }

  position.y += sin(millis()) / 2;

  image(ghostCurrent, position.x, position.y);
  
    if (debug) {
    noFill();
    noStroke();
    ellipse(position.x, position.y, triggerDistance1*2, triggerDistance1*2);
    ellipse(position.x, position.y, triggerDistance2*2, triggerDistance2*2);
    line(target.x, target.y, position.x, position.y);
    noStroke();
    rect(target.x, target.y, 10, 10);
    }
}

void pickTarget() {
  target = new PVector(random(margin, width-margin), random(margin, height-margin));
}

color c = color(0);
float x = 250;
float y = 0;
float vy = 2;
float g = 9.8;
float dt = 0.02;
float k = 100;
float b = 1;
float te = 0;
float theta_initial= (float)Math.PI/3;
PVector[] rcmrel = new PVector[4];
PVector[] r = new PVector[4];
PVector[] v = new PVector[4];
{
r[0]=new PVector(225,100);
r[1]=new PVector(275,100);
r[2]=new PVector(275,150);
r[3]=new PVector(225,150);
v[0]=new PVector(0,0);
v[1]=new PVector(0,0);
v[2]=new PVector(0,0);
v[3]=new PVector(0,0);

}


PVector w = new PVector(0,0,0);
float theta = theta_initial;
float rxinix=(r[1].x+r[2].x+r[3].x+r[0].x)/4;
float rxiniy=(r[1].y+r[2].y+r[3].y+r[0].y)/4;
PVector xycm = new PVector(rxinix,rxiniy);
{
  rcmrel[0]=PVector.sub(r[0],xycm);
  rcmrel[1]=PVector.sub(r[1],xycm);
  rcmrel[2]=PVector.sub(r[2],xycm);
  rcmrel[3]=PVector.sub(r[3],xycm);
}
PVector vcm = new PVector(0,0);
PVector force = new PVector(0,0);
PVector torque = new PVector(0,0,0);
float mass = 0.5;
float t = 0;
float I = 200;
Table table;

void setup() {
  pushMatrix();
  translate(xycm.x, xycm.y);
  for (int j=0;j<4;j++){
  rcmrel[j].rotate(theta);
  }
  popMatrix();
  
  size(500,500);
  table = new Table();
    table.addColumn("time");
  table.addColumn("te");
  table.addColumn("z");
}

void draw() {
  background(255);
  checkcollision();
  move();
  saveFrame("output/task1_####.jpg");
}

void move() {
  vcm.y=vcm.y+(g+(force.y/mass))*dt;
  vcm.x=vcm.x+((force.x/mass))*dt;
  force = new PVector(0,0);
  xycm.x=xycm.x+vcm.x*dt;
  xycm.y=xycm.y+vcm.y*dt;
  w.add(PVector.mult(torque,(dt/I)));
  print(w);
  theta+=w.z*dt;
  te=0.5*mass*(vcm.x*vcm.x+vcm.y*vcm.y)+0.5*I*w.z*w.z+mass*g*(height-xycm.y);
  
  TableRow newRow = table.addRow();
  newRow.setFloat("time", t);
  newRow.setFloat("te", te);
  newRow.setFloat("z", height-xycm.y);
  saveTable(table, "data/new.csv");
  t+=dt;
  rotater();
  for (int i=0;i<4;i++){
    r[i]=PVector.add(xycm,rcmrel[i]);
    v[i]=PVector.add(vcm,rcmrel[i].cross(w));
  }
  
}


void rotater() {
  pushMatrix();
  translate(xycm.x, xycm.y);
  for (int j=0;j<4;j++){
  rcmrel[j].rotate(w.z*dt);
  }
  rotate(theta);
  display();
  popMatrix();
  //ellipse(r[0].x,r[0].y,10,10);
  //ellipse(r[1].x,r[1].y,10,10);
  //ellipse(r[2].x,r[2].y,10,10);
  //ellipse(r[3].x,r[3].y,10,10);
}


void checkcollision(){
  PVector[] forcer = new PVector[4];
  {
    forcer[0] = new PVector(0,0);
    forcer[1] = new PVector(0,0);
    forcer[2] = new PVector(0,0);
    forcer[3] = new PVector(0,0);
    
  }
  torque=new PVector(0,0,0);
  for (int i=0;i<4;i++){
    if (r[i].y>height){
    forcer[i].y=-k*(r[i].y-height)-b*v[i].y;
    torque.add(PVector.sub(r[i],xycm).cross(forcer[i]));
    force.y+=forcer[i].y;
    //print(torque);
    }
  }
  }


void display() {
  fill(c);
  rectMode(CENTER);
  rect(0,0,50,50);
}

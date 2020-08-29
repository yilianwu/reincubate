import peasy.*;
import controlP5.*;
import processing.opengl.*;

PeasyCam cam;
ControlP5 cp5;
Slider sl_r1,sl_delta_m,sl_spd;
Textarea myTextarea,servoInfo;
Textlabel intro;
float[] m_len=new float[3];
float[] m_deg=new float[3];
float theta;
float r1=250; //plate_r(mm)
float r2;
float delta_m=33; //0-33(mm) MAX=33
float delta_p; //plate edge height
double count;
float t=0;
double spd;
double offset=0.0001;

void setup() {
  frameRate(30);
  size(600, 600, P3D);
  cam = new PeasyCam(this, 0, 0, 0, 550);
  cam.setMinimumDistance(150);
  cam.setMaximumDistance(1200);
  
  delta_p=delta_m*4/3;
  theta=asin(delta_p/(r1*2));
  r2=r1*cos(theta);
  
  cp5=new ControlP5(this);
  sl_delta_m=cp5.addSlider("adj_m")
    .setPosition(20, 500)
    .setSize(200, 20)
    .setRange(0, 33)
    .setValue(33);
    ;
  sl_r1=cp5.addSlider("adj_r1")
    .setPosition(20, 460)
    .setSize(200, 20)
    .setDecimalPrecision(0) 
    .setRange(50, 500)
    .setValue(250)
    ;
  sl_spd=cp5.addSlider("adj_spd")
    .setPosition(20, 540)
    .setSize(200, 20)
    .setDecimalPrecision(3) 
    .setRange(0, 1)
    .setValue(0.3)
    ;
    
  myTextarea = cp5.addTextarea("num_data")
                  .setPosition(280,460)
                  .setSize(120,110)
                  .setFont(createFont("arial",11))
                  .setLineHeight(22)
                  .setColor(color(255))
                  .setColorBackground(color(0,200))
                  .setColorForeground(color(0,200))
                  ;
  servoInfo= cp5.addTextarea("m_data")
                  .setPosition(420,460)
                  .setSize(150,110)
                  .setFont(createFont("arial",11))
                  .setLineHeight(18)
                  .setColor(color(255))
                  .setColorBackground(color(0,200))
                  .setColorForeground(color(0,200))
                  ;
  intro= cp5.addTextlabel("info")
                  .setPosition(0,0)
                  .setSize(300,36)
                  .setFont(createFont("arial",18))
                  .setColor(color(5,5,120))
                  .setText("REINCUBATE Motion Simulator")
                  ;
  cp5.setAutoDraw(false);
}
void draw() {
  background(190);

  //count=frameCount*1000/30; //milliseconds
  count++;
  r1=sl_r1.getValue();
  delta_m=sl_delta_m.getValue();
  spd=sl_spd.getValue()*offset;
  t+=count*spd;
  delta_p=delta_m*4/3;
  theta=asin(delta_p/(r1*2));
  r2=r1*cos(theta);
  
  for (int i=0; i<3; i++) {
    m_len[i]=tan(theta)*(abs((cos(t)/sin(t))*r2*cos(TWO_PI*i/3)+r2*sin(TWO_PI*i/3)-(r2/sin(t)))/sqrt(sq(cos(t)/sin(t))+1));
    m_deg[i]=map(m_len[i],0,delta_p,0,180);
  }
  
  //Grids
  pushMatrix();
  for(int x=-600;x<=600;x+=50){
    for(int y=-600;y<=600;y+=50){
      stroke(125,125,125,11);
      strokeWeight(1);
      line(x,-600,-1,x,600,-1);
      line(-600,y,-1,600,y,-1);
    }
  }
  
  //axis X
  stroke(255,0,0,100);
  strokeWeight(1);
  line(-800,0,-1,800,0,-1);
  
  //axis Y
  stroke(0,255,0,100);
  strokeWeight(1);
  line(0,-800,-1,0,800,-1);
  
  //axis Z
  stroke(0,0,255,130);
  strokeWeight(1);
  line(0,0,-800,0,0,800);
  
  //cos plate
  fill(138, 137, 151,180);
  noStroke();
  ellipse(0, 0, r2*2, r2*2);
  
  //Line(AA')
  stroke(204, 0, 0,150);
  strokeWeight(3);
  line(r2*cos(TWO_PI), r2*sin(TWO_PI), 0, r2*cos(TWO_PI), r2*sin(TWO_PI), m_len[0]);
  fill(204, 0, 0,150);
  
  //Point(A)
  pushMatrix();
  textSize(11);
  textAlign(CENTER);
  translate(r2*1.05*cos(TWO_PI), r2*1.05*sin(TWO_PI), m_len[0]);
  rotateX(-HALF_PI);
  text('A',0,0,0);
  popMatrix();
  
  //Point(A')
  pushMatrix();
  translate(r2*1.05*cos(TWO_PI), r2*1.05*sin(TWO_PI), 0);
  rotateX(-HALF_PI);
  text("A\'",0,0, 0);
  popMatrix();
  
  //Line(BB')
  stroke(0, 128, 0);
  strokeWeight(3);
  line(r2*cos(TWO_PI/3), r2*sin(TWO_PI/3), 0, r2*cos(TWO_PI/3), r2*sin(TWO_PI/3), m_len[1]);
  fill(0, 128, 0);
  textSize(11);
  textAlign(CENTER);
  
  //Point(B)
  pushMatrix();
  translate((r2*1.05)*cos(TWO_PI/3), (r2*1.05)*sin(TWO_PI/3),m_len[1]);
  rotateX(-HALF_PI);
  text('B',0,0,0);
  popMatrix();
  
  //Point(B')
  pushMatrix();
  translate((r2*1.05)*cos(TWO_PI/3), (r2*1.05)*sin(TWO_PI/3),0);
  rotateX(-HALF_PI);
  text("B\'",0,0,0);
  popMatrix();
  
  //Line(CC')
  stroke(0, 0, 120);
  strokeWeight(3);
  line(r2*cos(TWO_PI*2/3), r2*sin(TWO_PI*2/3), 0, r2*cos(TWO_PI*2/3), r2*sin(TWO_PI*2/3), m_len[2]);
  fill(0, 0, 120);
  textSize(11);
  textAlign(CENTER);
  
  //Point(C)
  pushMatrix();
  translate((r2*1.05)*cos(TWO_PI*2/3), (r2*1.05)*sin(TWO_PI*2/3),m_len[2]);
  rotateX(-HALF_PI);
  text("C",0,0,0);
  popMatrix();
  
  //Point(C')
  pushMatrix();
  translate((r2*1.05)*cos(TWO_PI*2/3), (r2*1.05)*sin(TWO_PI*2/3),0);
  rotateX(-HALF_PI);
  text("C\'",0,0,0);
  popMatrix();
  
  //Point(P)
  pushMatrix();
  textSize(13);
  textAlign(CENTER);
  fill(24, 77, 49);
  translate((r2*1.05)*cos(t), (r2*1.05)*sin(t),5);
  rotateX(-HALF_PI);
  text('P',0,0,0);
  popMatrix();
  
  //Theta
  pushMatrix();
  textSize(11);
  textAlign(CENTER);
  translate((r2*0.6)*cos(t), (r2*0.6)*sin(t),1);
  rotateX(-HALF_PI);
  text('θ',0,0,0);
  popMatrix();
  
  //Theta area
  fill(245,240,106,120);
  noStroke();
  beginShape();
  vertex(r2*cos(t), r2*sin(t), 0);
  vertex(r2*cos(t-PI), r2*sin(t-PI), 0);
  vertex(r2*cos(t-PI), r2*sin(t-PI), delta_p);
  endShape();

  //Plate
  pushMatrix();
  translate(0, 0, r1*sin(theta));
  rotateX(theta*cos(t+HALF_PI));
  rotateY(theta*sin(t+HALF_PI));
  fill(123, 120, 251,50);
  stroke(255,255,255,80);
  strokeWeight(1);
  ellipse(0, 0, r1*2, r1*2);
  stroke(31,31,33,59);
  strokeWeight(4);
  line(0,0,-150,0,0,150);
  popMatrix();
  
  //Auxiliary line
  stroke(255,255,255);
  strokeWeight(1);
  stroke(204, 0, 0,150);
  line(r2*cos(TWO_PI), r2*sin(TWO_PI), 0.1, r2*cos(t), r2*sin(t), 0.1);
  stroke(0, 128, 0);
  line(r2*cos(TWO_PI/3), r2*sin(TWO_PI/3), 0.1, r2*cos(t), r2*sin(t), 0.1);
  stroke(0, 0, 120);
  line(r2*cos(TWO_PI*2/3), r2*sin(TWO_PI*2/3), 0.1, r2*cos(t), r2*sin(t), 0.1);
  
  popMatrix();
  
  myTextarea.setText("count = "+count+"\n"
    +"P ("+str(int(r2*cos(t)))+","+str(int(r2*sin(t)))+")"+"\n"
    +"spd = "+sl_spd.getValue()+"* 0.0001\n"
    +"θ = "+degrees(theta)
    );
    
  servoInfo.setText("AA' = "+m_len[0]+"\n"
    +"BB' = "+m_len[1]+"\n"
    +"CC' = "+m_len[2]+"\n"
    +"m1 = "+m_deg[0]+" ° \n"
    +"m2 = "+m_deg[1]+" ° \n"
    +"m3 = "+m_deg[2]+" °"
    );
    
  gui();
}

void gui() {
  
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  cp5.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}
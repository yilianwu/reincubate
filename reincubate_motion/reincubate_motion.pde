import peasy.*;
PeasyCam cam;
float[] m_len=new float[3];
float theta;
float r1=250; //plate_r(mm)
float r2;
float delta_m=33; //0-33(mm) MAX=33
float delta_p; //plate edge height
float count;
float t;
float spd=0.5;
void setup(){
  frameRate(30);
  size(600,600,P3D);
  cam = new PeasyCam(this,600);
  delta_p=(4/3)*delta_m;
  theta=asin(delta_p/(r1*2));
  r2=r1*cos(theta);
}
void draw(){
  background(255);
  count=frameCount;
  t=radians(count*spd);
  for(int i=0;i<3;i++){
  m_len[i]=tan(theta)*(abs((cos(t)/sin(t))*r2*cos(TWO_PI*i/3)+r2*sin(TWO_PI*i/3)-(r2/sin(t)))/sqrt(sq(cos(t)/sin(t))+1));
  }
  
  fill(125,125,125,100);
  noStroke();
  ellipse(0,0,r2*2,r2*2);
  stroke(204, 0, 0);
  line(r2*cos(TWO_PI),r2*sin(TWO_PI),0,r2*cos(TWO_PI),r2*sin(TWO_PI),m_len[0]);
  stroke(0, 102, 0);
  line(r2*cos(TWO_PI/3),r2*sin(TWO_PI/3),0,r2*cos(TWO_PI/3),r2*sin(TWO_PI/3),m_len[1]);
  stroke(0, 0, 120);
  line(r2*cos(TWO_PI*2/3),r2*sin(TWO_PI*2/3),0,r2*cos(TWO_PI*2/3),r2*sin(TWO_PI*2/3),m_len[2]);
  
  line(r2*cos(TWO_PI),r2*sin(TWO_PI),m_len[0],r2*cos(t),r2*sin(t),0);
  line(r2*cos(TWO_PI/3),r2*sin(TWO_PI/3),m_len[1],r2*cos(t),r2*sin(t),0);
  line(r2*cos(TWO_PI*2/3),r2*sin(TWO_PI*2/3),m_len[2],r2*cos(t),r2*sin(t),0);

  translate(0,0,r1*sin(theta));
  rotateX(theta*cos(t+HALF_PI));
  rotateY(theta*sin(t+HALF_PI));
  fill(0,0,125,50);
  ellipse(0,0,r1*2,r1*2);
  
}
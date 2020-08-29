#include <Servo.h>
Servo myservo[3];
float m_len[3];
float m_theta[3];
float theta; //培養皿傾斜夾角
float r1=250; //培養皿半徑(mm)
float r2;
float delta_m=33; //MAX = 33(mm)
float delta_p; //plate edge height
double count=0;
double t;
float spd=0.5;
void setup() {
  Serial.begin(9600);
  
  delta_p=(4/3)*delta_m;
  theta=asin(delta_p/(r1*2));
  r2=r1*cos(theta);

  myservo[0].attach(9);
  myservo[1].attach(10);
  myservo[2].attach(11);

  for(int i=0;i<3;i++){
    myservo[i].write(0); //reset
  }
}

void loop() {
  count=millis();
  t=count*spd*0.001;
  for(int i=0;i<3;i++){
  m_len[i]=tan(theta)*(abs((cos(t)/sin(t))*r2*cos(TWO_PI*i/3)+r2*sin(TWO_PI*i/3)-(r2/sin(t)))/sqrt(sq(cos(t)/sin(t))+1));
  m_theta[i]=mapf(m_len[i],0,delta_m,0,180);
  myservo[i].write(m_theta[i]);
  }
  
//  delay(30);

}

//map float number
float mapf(float x, float fromLow, float fromHigh, float toLow, float toHigh)
{
  return (x - fromLow) * (toHigh - toLow) / (fromHigh - fromLow) + toLow;
}

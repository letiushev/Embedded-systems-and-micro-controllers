const int analogInPin = A0;
const int analogOutPin = 9;

int sensorValue = 0; 
int outputValue = 0;
int prevS = 0;
long prevT = 0;
long ttc = 0; 

void setup() {
  pinMode(A5, OUTPUT);
  Serial.begin(9600);
}

void loop() {

  sensorValue = analogRead(analogInPin);
  outputValue = map(sensorValue, 0, 1023, 0, 255);
  long currentT = millis();
  float velocity = ((float)(outputValue - prevS)/(currentT - prevT))*10;

  ttc = (outputValue/velocity);
  
  analogWrite(analogOutPin, outputValue);

  Serial.print("v= ");
  Serial.print(velocity);
  Serial.print("\t ttc= ");
  Serial.println(ttc);

  if (ttc<150 && 0<ttc){
    digitalWrite(A5, HIGH); //light the led 
  }
  else
  {
    digitalWrite(A5, LOW); //put out the led
  }

  prevT=millis();
  prevS=outputValue; 
  
  delay(100);                    
}

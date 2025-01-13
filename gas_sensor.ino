#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include <DHT.h>

// Provide the token generation process info.
#include <addons/TokenHelper.h>

// Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>

/* 1. Define the WiFi credentials */
#define WIFI_SSID "heh"
#define WIFI_PASSWORD "abcd1234"

/* 2. Define the API Key */
#define API_KEY "AIzaSyAk0Id6Sg92ELerdqVK-B0t62f3byNb0Kg"

/* 3. Define the RTDB URL */
#define DATABASE_URL "https://esp8266-project-ca7ef-default-rtdb.europe-west1.firebasedatabase.app/" 

/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "app@gmail.com"
#define USER_PASSWORD "123456"

// Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;

const int gasPin = 5;
const int ledPin = 4;
DHT dht(26, DHT11);
int OUT_PIN_SOUND = 18;

int ledPirPin = 21;   // Buildin LED on pin 13 of the Arduino
int pirPin = 23;   // Pin for the HC-S501 sensor
int pirValue; 

const int motorspeed_pin = 32; //change this
const int DIRA = 33; //change this
const int DIRB = 25;  //change this
const int delayOn =3000;
const int delayOff =1500;

void setup()
{
  pinMode(ledPirPin, OUTPUT);    // Set the ledPin as output
  pinMode(pirPin, INPUT);     // Set the pirPin as input
  digitalWrite(ledPirPin, LOW);  // Turn off the LED

  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);

  pinMode(gasPin, INPUT);
  dht.begin();
    pinMode(OUT_PIN_SOUND, INPUT);

    ///fan
  pinMode(motorspeed_pin, OUTPUT);
  pinMode(DIRA, OUTPUT);
  pinMode(DIRB, OUTPUT);

  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

   /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h


  // Comment or pass false value when WiFi reconnection will control by your code or third party library e.g. WiFiManager
  Firebase.reconnectNetwork(true);

  // Since v4.4.x, BearSSL engine was used, the SSL buffer need to be set.
  // Large data transmission may require larger RX buffer, otherwise connection issue or data read time out can be occurred.
  fbdo.setBSSLBufferSize(4096 /* Rx buffer size in bytes from 512 - 16384 */, 1024 /* Tx buffer size in bytes from 512 - 16384 */);

  // Limit the size of response payload to be collected in FirebaseData
  fbdo.setResponseSize(2048);

  Firebase.begin(&config, &auth);

  Firebase.setDoubleDigits(5);

  config.timeout.serverResponse = 10 * 1000;
}

void turnOff()
{
 //this instruction is used to set the speed of the motor to 0 (off)
 digitalWrite(motorspeed_pin, LOW);
 //in these instructions the state is irrelevant because the motor is off 
 digitalWrite(DIRA, LOW);
 digitalWrite(DIRB, LOW);
 //wait 1.5 seconds
 //delay(delayOff);
}


void loop()
{
   pirValue = digitalRead(pirPin); // Read the PIR value
  digitalWrite(ledPirPin, pirValue); // Write the PIR value to the buildin LED

  // Firebase.ready() should be called repeatedly to handle authentication tasks.
  if (Firebase.ready() && (millis() - sendDataPrevMillis > 2000 || sendDataPrevMillis == 0))
  {
    sendDataPrevMillis = millis();

    Serial.printf("Gas Leak: %s\n", Firebase.RTDB.setBool(&fbdo, F("/house/gas-leak"), digitalRead(gasPin) == 0) ? "ok" : fbdo.errorReason().c_str());
    Serial.printf("Sound: %s\n", Firebase.RTDB.setBool(&fbdo, F("/house/sound"), digitalRead(OUT_PIN_SOUND) == 0) ? "ok" : fbdo.errorReason().c_str());
    Serial.printf("Movement: %s\n", Firebase.RTDB.setBool(&fbdo, F("/house/movement"), digitalRead(pirPin) == 0) ? "ok" : fbdo.errorReason().c_str());
   


    // Reading temperature or humidity takes about 250 milliseconds!
    // Sensor readings may also be up to 2 seconds 'old' (its a very slow sensor)
    float h = dht.readHumidity();
    // Read temperature as Celsius
    float t = dht.readTemperature();

    // Check if any reads failed and exit early (to try again).
    if (isnan(h) || isnan(t)) {
      Serial.println(F("Failed to read from DHT sensor!"));
      return;
    }
    Serial.printf("Temperature: %s\n", Firebase.RTDB.setFloat(&fbdo, F("/house/temp"), t) ? "ok" : fbdo.errorReason().c_str());
    Serial.printf("Humidity: %s\n", Firebase.RTDB.setFloat(&fbdo, F("/house/humidity"), h) ? "ok" : fbdo.errorReason().c_str());
  }

  int ledState;
   if(Firebase.RTDB.getInt(&fbdo, "/led/state", &ledState)){
    digitalWrite(ledPin, ledState);
   }else{
    Serial.println(fbdo.errorReason().c_str());
   }


   int fanState;
    if(Firebase.RTDB.getInt(&fbdo, "/house/fan/state", &fanState)){
          if(fanState == 1){
             Serial.println("turned on");
            digitalWrite(motorspeed_pin, HIGH);
            //these instructions are used to turn on the motor in one direction
            digitalWrite(DIRA, HIGH);
            digitalWrite(DIRB, LOW);
          }
          else if(fanState == 0){
            turnOff();
          }
          
    }else{
      Serial.println(fbdo.errorReason().c_str());
    }

  int fanAutomatic;
  int temp;
  int isAutomatic;
    if(Firebase.RTDB.getInt(&fbdo, "/house/fan/automatic", &fanAutomatic) && Firebase.RTDB.getInt(&fbdo, "/house/temp", &temp) && Firebase.RTDB.getInt(&fbdo, "/house/fan/isAutomatic", &isAutomatic)){
         if (isAutomatic ==1){
          Serial.println("is automatic");
          if(fanAutomatic <= temp){
            digitalWrite(motorspeed_pin, HIGH);
            //these instructions are used to turn on the motor in one direction
            digitalWrite(DIRA, HIGH);
            digitalWrite(DIRB, LOW);
          }
          else if(fanAutomatic >= temp ){
            turnOff();
          }
         }
          
    }else{
      Serial.println(fbdo.errorReason().c_str());
    }

  

}

#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>

#define WIFI_SSID "your_SSID"
#define WIFI_PASSWORD "your_PASSWORD"
#define FIREBASE_HOST "your_firebase_host"
#define FIREBASE_AUTH "your_firebase_auth"

FirebaseData firebaseData;
FirebaseAuth auth;
FirebaseConfig config;

const int ledPin = 2; // Onboard LED pin

void setup() {
  Serial.begin(115200);
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, HIGH); // Ensure LED is off at startup (Active LOW)

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi");

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println(" Connected!");

  config.host = FIREBASE_HOST;
  config.signer.tokens.legacy_token = FIREBASE_AUTH;
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void loop() {
  if (Firebase.getInt(firebaseData, "/led/state")) {
    int ledState = firebaseData.to<int>();
    Serial.print("LED State: ");
    Serial.println(ledState == 1 ? "ON" : "OFF");

    digitalWrite(ledPin, ledState == 1 ? LOW : HIGH); // Control onboard LED (Active LOW)
  } else {
    Serial.print("Error: ");
    Serial.println(firebaseData.errorReason());
  }

  // Generate random temperature and humidity values
  int temperature = random(20, 35); // Random temperature between 20°C and 35°C
  int humidity = random(30, 70);    // Random humidity between 30% and 70%

  // Send random data to Firebase
  Firebase.setInt(firebaseData, "/sensor/temperature", temperature);
  Firebase.setInt(firebaseData, "/sensor/humidity", humidity);

  // Display values on Serial Monitor
  Serial.print("Temperature: ");
  Serial.print(temperature);
  Serial.print("°C, Humidity: ");
  Serial.print(humidity);
  Serial.println("%");

  delay(1000); // Real-time like behavior with 1-second interval
}

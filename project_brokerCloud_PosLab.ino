#include <ESP8266WiFi.h>
#include <PubSubClient.h>

// Update these with values suitable for your network.

const char* ssid = "izaque";
const char* password = "izaque123";
const char* mqtt_broker = "89027d54046045d3954ec8a3d6c7c9cf.s2.eu.hivemq.cloud";
const int mqtt_port = 8883;

String user = "placa";
String passwd = "garsoft-je05";
static const char *fingerprint PROGMEM = "EA 59 CA BD 80 01 01 E8 12 58 B6 4E A3 59 2B 5A 6E 60 BC F5";


WiFiClientSecure espClient;
PubSubClient client(espClient);
unsigned long lastMsg = 0;
#define MSG_BUFFER_SIZE  (50)
char msg[MSG_BUFFER_SIZE];
int leds_lido[2];
int value = 0;
unsigned int word_length = 4;
int ganhou;
int perdeu;

int tempoMQTT = 5000;

#define LEDS0 D6
#define LEDS1 D5
#define LEDS2 D0
#define CHAVES0 D4 
#define CHAVES1 D3
#define CHAVES2 D2
#define CHAVES3 D1
#define PERDEU D7
#define GANHOU D8

/* é necessário definir mais pinos para algumas variáveis que foram criadas,
mas para isso seria necessario adquirir uma nova placa */

void setup() {
    // Initialize the BUILTIN_LED pin as an
    // output
  pinMode(BUILTIN_LED, OUTPUT);   
  Serial.begin(115200);
  setup_wifi();
  espClient.setInsecure();
  //espClient.setCACert(root_ca);
  connect_mqtt();
  espClient.setFingerprint(fingerprint); 
  pinMode(LEDS0, INPUT);
  pinMode(LEDS1, INPUT);
  pinMode(LEDS2, INPUT);
//pinMode(INICIAR, OUTPUT);
//pinMode(RESET, OUTPUT);
  pinMode(CHAVES0, OUTPUT);
  pinMode(CHAVES1, OUTPUT);
  pinMode(CHAVES2, OUTPUT);
  pinMode(CHAVES3, OUTPUT);
  pinMode(GANHOU, INPUT);
  pinMode(PERDEU, INPUT);
}

void loop() {
  client.loop();
  
  leds_lido[0] = digitalRead(LEDS0);
  leds_lido[1] = digitalRead(LEDS1);
  leds_lido[2] = digitalRead(LEDS2);
  ganhou = digitalRead(GANHOU);
  perdeu = digitalRead(PERDEU);
  for(int i=0; i<3; i++) {
    if(leds_lido[0] != 0 && leds_lido[1] != 0 && leds_lido[2] != 0){
      Serial.print(leds_lido[i]);
     
    }
  }
  if (leds_lido[0] == 1 && leds_lido[1] == 0 && leds_lido[2] == 0) {
    client.publish("leds/", "0001"); 
    delay(1000);
  }
  if (leds_lido[0] == 0 && leds_lido[1] == 1 && leds_lido[2] == 0) {
    client.publish("leds/", "0010"); 
    delay(1000);
  }
  if (leds_lido[0] == 0 && leds_lido[1] == 0 && leds_lido[2] == 1) {
    client.publish("leds/", "0100"); 
    delay(1000);
  }
  if (leds_lido[0] == 1 && leds_lido[1] == 1 && leds_lido[2] == 1){
    client.publish("leds/", "1000");
    delay(1000);
  }
  
  if (ganhou == 1) {
    client.publish("ganhou/", "1"); 
  }
  if (perdeu == 1) {
    client.publish("perdeu/", "1");  
  }

  delay(1);
}

void connect_mqtt() {
    // MQTT
    client.setServer(mqtt_broker, mqtt_port);
    client.setCallback(callback);
    while (!client.connected()) {
        // Client Connection
        String client_id = "esp32-client-";
        client_id += String(WiFi.macAddress());
        Serial.printf("Client ID: %s\n", client_id.c_str());
        if (client.connect(client_id.c_str(), user.c_str(), passwd.c_str())) {
          Serial.println("Public emqx mqtt broker connected");
          client.subscribe("botoes/");
          client.subscribe("iniciar/"); // se inscreve no topico para controle do sinal iniciar na fpga
          client.subscribe("reset/"); // se inscreve no topico para controle do sinal reset na fpga
        }
        // Failed
        else{
          Serial.print("failed with state ");
          Serial.print(client.state());
          delay(tempoMQTT);
        }
    }
}

void setup_wifi() {

  delay(10);
  // We start by connecting to a WiFi network
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  randomSeed(micros());

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println();

  if (strcmp("iniciar/", topic)==0 && (char)payload[0]=='1') {
    digitalWrite(CHAVES0, LOW);
    digitalWrite(CHAVES1, HIGH);
    digitalWrite(CHAVES2, LOW);
    digitalWrite(CHAVES3, HIGH);
    delay(100);
    digitalWrite(CHAVES0, LOW);
    digitalWrite(CHAVES1, LOW);
    digitalWrite(CHAVES2, LOW);
    digitalWrite(CHAVES3, LOW);
    Serial.println("iniciou");
  } 

  if (strcmp("reset/", topic)==0 && (char)payload[0]=='1') {
    digitalWrite(CHAVES0, HIGH);
    digitalWrite(CHAVES1, HIGH);
    digitalWrite(CHAVES2, LOW);
    digitalWrite(CHAVES3, HIGH);
    delay(100);
    digitalWrite(CHAVES0, LOW);
    digitalWrite(CHAVES1, LOW);
    digitalWrite(CHAVES2, LOW);
    digitalWrite(CHAVES3, LOW);
    Serial.println("resetou");
  }

  if(strcmp("botoes/", topic) == 0){
      if ((char)payload[0] == '0' && (char)payload[1] == '0' && (char)payload[2] == '0' && (char)payload[3] == '0') {
        digitalWrite(CHAVES0, LOW);
        digitalWrite(CHAVES1, LOW);
        digitalWrite(CHAVES2, LOW);
        digitalWrite(CHAVES3, LOW);
      }
      else if ((char)payload[0] == '0' && (char)payload[1] == '0' && (char)payload[2] == '0' && (char)payload[3] == '1') {
        digitalWrite(CHAVES0, HIGH);
        digitalWrite(CHAVES1, LOW);
        digitalWrite(CHAVES2, LOW);
        digitalWrite(CHAVES3, LOW);
        delay(150);
        digitalWrite(CHAVES0, LOW);
        digitalWrite(CHAVES1, LOW);
        digitalWrite(CHAVES2, LOW);
        digitalWrite(CHAVES3, LOW);
      }
      else if ((char)payload[0] == '0' && (char)payload[1] == '0' && (char)payload[2] == '1' && (char)payload[3] == '0') {
        digitalWrite(CHAVES0, LOW);
        digitalWrite(CHAVES1, HIGH);
        digitalWrite(CHAVES2, LOW);
        digitalWrite(CHAVES3, LOW);
        delay(150);
        digitalWrite(CHAVES0, LOW);
        digitalWrite(CHAVES1, LOW);
        digitalWrite(CHAVES2, LOW);
        digitalWrite(CHAVES3, LOW);
      }
      else if ((char)payload[0] == '0' && (char)payload[1] == '1' && (char)payload[2] == '0' && (char)payload[3] == '0') {
        digitalWrite(CHAVES0, LOW);
        digitalWrite(CHAVES1, LOW);
        digitalWrite(CHAVES2, HIGH);
        digitalWrite(CHAVES3, LOW);
        delay(150);
        digitalWrite(CHAVES0, LOW);
        digitalWrite(CHAVES1, LOW);
        digitalWrite(CHAVES2, LOW);
        digitalWrite(CHAVES3, LOW);
      }
      else {
        digitalWrite(CHAVES0, LOW);
        digitalWrite(CHAVES1, LOW);
        digitalWrite(CHAVES2, LOW);
        digitalWrite(CHAVES3, HIGH);
        delay(150);
        digitalWrite(CHAVES0, LOW);
        digitalWrite(CHAVES1, LOW);
        digitalWrite(CHAVES2, LOW);
        digitalWrite(CHAVES3, LOW);
      }
    }
} 

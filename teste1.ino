#include <ESP8266WiFi.h>
#include <PubSubClient.h>

// Update these with values suitable for your network.

const char* ssid = "izaque";
const char* password = "izaque123";
const char* mqtt_broker = "labdigi.wiseful.com.br";
const int mqtt_port = 80;

String user = "grupo2-bancadaA1";
String passwd = "digi#@2A1";

WiFiClient espClient;
PubSubClient client(espClient);
unsigned long lastMsg = 0;
#define MSG_BUFFER_SIZE  (50)
char msg[MSG_BUFFER_SIZE];
int leds_lido[3];
int value = 0;
unsigned int word_length = 4;

int tempoMQTT = 5000;

#define LEDS0 D8
#define LEDS1 D7
#define LEDS2 D6
#define LEDS3 D5
#define INICIAR D4

/* é necessário definir mais pinos para algumas variáveis que foram criadas,
mas para isso seria necessario adquirir uma nova placa */

void setup() {
  pinMode(BUILTIN_LED, OUTPUT);     // Initialize the BUILTIN_LED pin as an output
  Serial.begin(115200);
  setup_wifi();
  connect_mqtt();
  pinMode(LEDS0, INPUT);
  pinMode(LEDS1, INPUT);
  pinMode(LEDS2, INPUT);
  pinMode(LEDS3, INPUT);
  pinMode(INICIAR, OUTPUT);
}

void loop() {

  client.loop();
  leds_lido[0] = digitalRead(LEDS0);
  leds_lido[1] = digitalRead(LEDS1);
  leds_lido[2] = digitalRead(LEDS2);
  leds_lido[3] = digitalRead(LEDS3);
  acertou = digitalRead(ACERTOU);
  perdeu = digitalRead(PERDEU);


  for(i=0; i<4; i++) {
    Serial.print(leds_lido[i]);
  }
  Serial.println();

  if (leds_lido[0] == 0 && leds_lido[1] == 0 && leds_lido[2] == 0) {
    client.publish("grupo2-bancadaA1/leds", "0000"); 
  }
  else if (leds_lido[0] == 1 && leds_lido[1] == 0 && leds_lido[2] == 0) {
    client.publish("grupo2-bancadaA1/leds", "0001"); 
  }
  else if (leds_lido[0] == 0 && leds_lido[1] == 1 && leds_lido[2] == 0) {
    client.publish("grupo2-bancadaA1/leds", "0010"); 
  }
  else if (leds_lido[0] == 0 && leds_lido[1] == 0 && leds_lido[2] == 1) {
    client.publish("grupo2-bancadaA1/leds", "0100"); 
  }
  else {
    client.publish("grupo2-bancadaA1/leds", "1000");
  }

  client.publish("grupo2-bancadaA1/acertou", ACERTOU);
  client.publish("grupo2-bancadaA1/perdeu", PERDEU);
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
          client.subscribe("grupo2-bancadaA1/teste_world");
          client.subscribe("grupo2-bancadaA1/iniciar"); // se inscreve no topico para controle do sinal iniciar na fpga
          client.subscribe("grupo2-bancadaA1/reset"); // se inscreve no topico para controle do sinal reset na fpga
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

  if (strcmp("grupo2-bancadaA1/iniciar", topic)==0 && (char)payload[0]=='1') {
    // A saída do ESP8266 é 5v quando é LOW e 0v quando é HIGH
    digitalWrite(INICIAR, HIGH);
    delay(3);
    digitalWrite(INICIAR, LOW);
    Serial.println("escreveu");
    
  } 

  if (strcmp("grupo2-bancadaA1/reset", topic)==0 && (char)payload[0]=='1') {
    // A saída do ESP8266 é 5v quando é LOW e 0v quando é HIGH
    digitalWrite(RESET, HIGH);
    delay(3);
    digitalWrite(RESET, LOW);
    Serial.println("escreveu");
  }

  if(strcmp("grupo2-bancadaA1/chaves", topic())){
      if (leds_lido[0] == 0 && leds_lido[1] == 0 && leds_lido[2] == 0 && leds_lido[3] == 0) {
        escreveZero();
        digitalWrite(CHAVES0, LOW);
        digitalWrite(CHAVES1, LOW);
        digitalWrite(CHAVES2, LOW);
        digitalWrite(CHAVES3, LOW);
      }
      else if (leds_lido[0] == 1 && leds_lido[1] == 0 && leds_lido[2] == 0 && leds_lido[3] == 0) {
        digitalWrite(CHAVES0, HIGH);
        digitalWrite(CHAVES1, LOW);
        digitalWrite(CHAVES2, LOW);
        digitalWrite(CHAVES3, LOW);
        delay(2)
        digitalWrite(CHAVES0, LOW);
        digitalWrite(CHAVES1, LOW);
        digitalWrite(CHAVES2, LOW);
        digitalWrite(CHAVES3, LOW);
      }
      else if (leds_lido[0] == 0 && leds_lido[1] == 1 && leds_lido[2] == 0 && leds_lido[3] == 0) {
        digitalWrite(CHAVES0, LOW);
        digitalWrite(CHAVES1, HIGH);
        digitalWrite(CHAVES2, LOW);
        digitalWrite(CHAVES3, LOW);
        delay(2)
        digitalWrite(CHAVES0, LOW);
        digitalWrite(CHAVES1, LOW);
        digitalWrite(CHAVES2, LOW);
        digitalWrite(CHAVES3, LOW);
      }
      else if (leds_lido[0] == 0 && leds_lido[1] == 0 && leds_lido[2] == 1 && leds_lido[3] == 0) {
        digitalWrite(CHAVES0, LOW);
        digitalWrite(CHAVES1, LOW);
        digitalWrite(CHAVES2, HIGH);
        digitalWrite(CHAVES3, LOW);
        delay(2)
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
        delay(2)
        digitalWrite(CHAVES0, LOW);
        digitalWrite(CHAVES1, LOW);
        digitalWrite(CHAVES2, LOW);
        digitalWrite(CHAVES3, LOW);
      }
    }
} 


//-----------------------PIN DEFINITION-----------------------//
// Definition of H-Bridge pins and limit switches

//_______DIFFRACTOR_______
int IN1_DIFRA = 22; // Stepper motor coil 1
int IN2_DIFRA = 23; // Stepper motor coil 2
int IN3_DIFRA = 24; // Stepper motor coil 3
int IN4_DIFRA = 25; // Stepper motor coil 4

int ORIGEM_DIFRA = 34; // Limit switch for diffractor
//________________________

//_______LAMP_______
int IN1_LAMP = 49; // Stepper motor coil 1
int IN2_LAMP = 48; // Stepper motor coil 2
int IN3_LAMP = 51; // Stepper motor coil 3
int IN4_LAMP = 50; // Stepper motor coil 4

int ORIGEM_LAMP = 43; // Limit switch for lamp
int TIPO_LAMP = 36;   // Lamp type control (VIS/UV)
//__________________

//________FILTER________
int IN1_FILTRO = 26; // Stepper motor coil 1
int IN2_FILTRO = 27; // Stepper motor coil 2
int IN3_FILTRO = 28; // Stepper motor coil 3
int IN4_FILTRO = 29; // Stepper motor coil 4

int ORIGEM_FILTRO = 35; // Limit switch for filter
//______________________

//-----------------------------------------------------------//

// Interrupt pin to synchronize Arduino power with motor power
int fonte = 2; // If the power source is turned off, an interrupt is triggered to stop program execution

//----------------------VARIABLE DEFINITION--------------------//
//______PHOTODIODES______
int IC1 = A3;               // Photodiode 1
int IC2 = A2;               // Photodiode 2
int integration = 100;      // Number of measurements for averaged intensity
int contador_integ = 0;     // Integration counter
float intensity_IC1 = 0;    // Weighted intensity from IC1
float intensity_IC2 = 0;    // Weighted intensity from IC2
//________________________

//_______DIFFRACTOR_______
int DELAY_DIFRA = 10;       // Step delay for diffractor
int gotocount;              // Stores current wavelength position
//_________________________

//_______LAMP_______
int DELAY_LAMP = 50;        // Step delay for lamp
//__________________

//________FILTER________
int DELAY_FILTRO = 50;      // Step delay for filter
int filtro_0 = 53;          // Filter position 0
int filtro_1 = 63;          // Filter position 1
int filtro_2 = 75;          // Filter position 2
int filtro_3 = 82;          // Filter position 3
int filtro_4 = 93;          // Filter position 4
int filtro_5 = 102;         // Filter position 5
int countfenda = 0;         // Counter for slit selection
int countfenda2 = 0;        // Counter for slit selection
int countfenda3 = 0;        // Counter for slit selection
//______________________

//________MISC________
int incomingByte = 0;       // Stores incoming serial data
const unsigned int max_value_length = 8; // Max characters for incoming value
static char value[max_value_length];     // Stores the received value
static unsigned int value_count = 0;     // Counter for characters in received value
//______________________

void setup() 
{
  Serial.begin(9600); // Begin serial communication at 9600 baud

//____________FILTER____________
  pinMode(IN1_FILTRO, OUTPUT);
  pinMode(IN2_FILTRO, OUTPUT);
  pinMode(IN3_FILTRO, OUTPUT);
  pinMode(IN4_FILTRO, OUTPUT);
  pinMode(ORIGEM_FILTRO, INPUT); 
//______________________________

//___________DIFFRACTOR___________
  pinMode(IN1_DIFRA, OUTPUT);
  pinMode(IN2_DIFRA, OUTPUT);
  pinMode(IN3_DIFRA, OUTPUT);
  pinMode(IN4_DIFRA, OUTPUT);
  pinMode(ORIGEM_DIFRA, INPUT);
//______________________________  

//___________LAMP____________
  pinMode(IN1_LAMP, OUTPUT); // Output pins for lamp motor
  pinMode(IN2_LAMP, OUTPUT);
  pinMode(IN3_LAMP, OUTPUT);
  pinMode(IN4_LAMP, OUTPUT);
  pinMode(ORIGEM_LAMP, INPUT);
  pinMode(TIPO_LAMP, OUTPUT); // Control pin for lamp type
//____________________________  

//__________PHOTODIODES__________
// Analog pins for photodiodes do not need to be declared as input in Arduino
//______________________________

// Buttons and power control
  pinMode(fonte, INPUT); // Interrupt pin to halt program if motor power is off

// Analog reference voltage for readings
  analogReference(3.3); // Reference voltage set to 3.3V
//______________________________ 
}

void loop() 
{ 
  if(Serial.available()) // Check if serial data is available
  {
    switch (Serial.read()) // Read the incoming byte
    {
      case 'i': // Initialization routine
      {
        Inicia_Difrator();  // Initialize diffractor
        delay(2000);

        Inicia_Filtro();    // Initialize filter
        delay(2000);

        Inicia_Lampada();   // Initialize lamp
        delay(2000);
        Rotina_Lampada(1);  // Turn on VIS lamp
        digitalWrite(TIPO_LAMP, 0); // Set VIS lamp mode

        Serial.print(0); // Send acknowledgment
        break;
      }
      
      case 'm': // Measure intensity IC1 moving forward
      {
        intensity_IC1 = 0;
        frente_DIFRA(DELAY_DIFRA);
        for(int count = 0; count < integration; count++)
        {
          intensity_IC1 += analogRead(IC1);
        }
        intensity_IC1 /= integration; // Calculate average intensity
        Serial.print(intensity_IC1); // Send intensity value via serial
        break;
      }
      
      case 'n': // Measure intensity IC1 moving backward
      {
        intensity_IC1 = 0;
        tras_DIFRA(DELAY_DIFRA);
        for(int count = 0; count < integration; count++)
        {
          intensity_IC1 += analogRead(IC1);
        }
        intensity_IC1 /= integration; // Calculate average intensity
        Serial.print(intensity_IC1); // Send intensity value via serial
        break;
      }

      // Other cases continue here with similar structure...
    }
  }
}




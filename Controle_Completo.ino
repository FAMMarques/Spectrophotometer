//-----------------------DEFINIÇÃO DOS PINOS-----------------------//
//  Compreende a definição dos pinos da ponte-H e do fim de curso

//_______DIFRATOR_______
int IN1_DIFRA = 22;
int IN2_DIFRA = 23;
int IN3_DIFRA = 24;
int IN4_DIFRA = 25;

int ORIGEM_DIFRA = 34;
//______________________

//_______LAMPADA________
int IN1_LAMP = 49;
int IN2_LAMP = 48;
int IN3_LAMP = 51;
int IN4_LAMP = 50;

int ORIGEM_LAMP = 43;
int TIPO_LAMP = 36;
//______________________

//________FILTRO________
int IN1_FILTRO = 26;
int IN2_FILTRO = 27;
int IN3_FILTRO = 28;
int IN4_FILTRO = 29;

int ORIGEM_FILTRO = 35;
//______________________
//-----------------------------------------------------------------//

//Conexão de interrupção para sincronizar a alimentação do arduino com a alimentação dos motores
int fonte = 2;    //se a fonte for desligada, chama interrupção pra parar de ler o programa
//TIRAR DEPOISSSS

//----------------------DEFINIÇÃO DAS VARIÁVEIS--------------------//
//______FOTODIODOS______
int IC1 = A3;
int IC2 = A2;
int integration = 100;  //número de medidas para cada intensidade ponderada
int contador_integ = 0; //contador de integrações
float intensity_IC1 = 0;    //intensidade ponderada IC1
float intensity_IC2 = 0;    //IC2

//______________________

//_______DIFRATOR_______
int DELAY_DIFRA = 10;
int gotocount;          //guarda comprimento de onda atual
//______________________

//_______LAMPADA________
int DELAY_LAMP = 50;
//______________________

//________FILTRO________
int DELAY_FILTRO = 50;
int filtro_0 = 53;
int filtro_1 = 63;
int filtro_2 = 75;
int filtro_3 = 82;
int filtro_4 = 93;
int filtro_5 = 102;
int countfenda = 0;  // contador para selecionar a fenda (slit)
int countfenda2 = 0;  // contador para selecionar a fenda (slit)
int countfenda3 = 0;  // contador para selecionar a fenda (slit)
//______________________

//________DEMAIS________
int incomingByte = 0;   //for incoming serial data
const unsigned int  max_value_length = 8;
static char value[max_value_length];
static unsigned int value_count = 0;
//______________________



void setup() 
{
  Serial.begin(9600);

//____________FILTRO____________
  pinMode(IN1_FILTRO,OUTPUT);
  pinMode(IN2_FILTRO,OUTPUT);
  pinMode(IN3_FILTRO,OUTPUT);
  pinMode(IN4_FILTRO,OUTPUT);
  pinMode(ORIGEM_FILTRO, INPUT); 
//______________________________

//___________DIFRATOR___________
  pinMode(IN1_DIFRA,OUTPUT);
  pinMode(IN2_DIFRA,OUTPUT);
  pinMode(IN3_DIFRA,OUTPUT);
  pinMode(IN4_DIFRA,OUTPUT);
  pinMode(ORIGEM_DIFRA, INPUT);
//______________________________  

//___________LAMPADA____________
  pinMode(IN1_LAMP,OUTPUT);     // neste momento não há implementação do controle da fonte de luz
  pinMode(IN2_LAMP,OUTPUT);
  pinMode(IN3_LAMP,OUTPUT);
  pinMode(IN4_LAMP,OUTPUT);
  pinMode(ORIGEM_LAMP, INPUT);
  pinMode(TIPO_LAMP, OUTPUT);
//______________________________  

//__________FOTODIODOS__________
//  pinMode(IC1, INPUT);        // no código de referencia, o pino analógico não é declarado
//  pinMode(IC2, INPUT); 

//botões
  pinMode(fonte,INPUT);           // função interrupção que para de ler o programa se as fonte dos motores for desligada

// Interrupções para sincronizar as fontes e resetar a varredura

//attachInterrupt(digitalPinToInterrupt(botao4), reset, CHANGE);
//attachInterrupt(digitalPinToInterrupt(fonte), espera, FALLING);

  analogReference(3.3); // tensão de referência
//______________________________ 
}

void loop() 
{ 
  if(Serial.available())
  {
    switch (Serial.read())
    {
      case 'i': // caso de inicialização
      {
        Inicia_Difrator();
        delay(2000);

        Inicia_Filtro();
        delay(2000);

        Inicia_Lampada();
        delay(2000);
        Rotina_Lampada(1);
        digitalWrite(TIPO_LAMP, 0); // Liga a lampada VIS

//_____________________Primeiro filtro________________________
//        for (int count=0; count<13; count++) 
//        {
//          tras_FILTRO(DELAY_FILTRO,4);        
//        }
//        Desliga_Motor_Filtro();
//____________________________________________________________
        Serial.print(0);
        break;
      }
      
      case 'm': // caso da medida para frente do IC1
      {
        intensity_IC1 = 0;
        frente_DIFRA(DELAY_DIFRA);
          for(int count = 0; count < integration; count++)
          {
            intensity_IC1 = analogRead(IC1) + intensity_IC1;
          }
        intensity_IC1 = intensity_IC1/integration;
        Serial.print(intensity_IC1);
        break;
      }
      case 'n': // caso da medida pra trás do IC1
      {
        intensity_IC1 = 0;
        tras_DIFRA(DELAY_DIFRA);
          for(int count = 0; count < integration; count++)
          {
            intensity_IC1 = analogRead(IC1) + intensity_IC1;
          }
        intensity_IC1 = intensity_IC1/integration;
        Serial.print(intensity_IC1);
        break;
      }
      case 'a': // caso da medida para frente do IC2
      {
        intensity_IC2 = 0;
        for(int count = 0; count < integration; count++)
        {
          intensity_IC2 = analogRead(IC2) + intensity_IC2;
        }
        intensity_IC2 = intensity_IC2/integration;
        Serial.print(intensity_IC2);
        break;
      }
      case 'b': // caso da medida pra trás pra IC2
      {
        intensity_IC2 = 0;
        for(int count = 0; count < integration; count++)
        {
          intensity_IC2 = analogRead(IC2) + intensity_IC2;
        }
        intensity_IC2 = intensity_IC2/integration;
        Serial.print(intensity_IC2);
        break;
      }
      case 'c': // caso de troca de lâmpada para a visível
      {
        Rotina_Lampada(1);
        break;
      }
      case 'e': // caso de troca de lâmpada para a UV
      {
        Rotina_Lampada(0);
        break;
      }
      
      case 'p': // caso da pré-medida
      {
        delay(100);
        while (Serial.available() > 0) 
        {
          // read the incoming byte:
          incomingByte = Serial.read();
          if (incomingByte != '\r') 
          {      
            value[value_count] = incomingByte;
            value_count++;      
          }
          else 
          {
            value[value_count] = '\0';
            integration = atoi(value);          
            value_count = 0;
          }
        }
        Serial.print(integration);   
        break;
      }
      case 'g': // caso "goto" para frente
      {
        for(int count = 0; count < gotocount; count++)
          {
            frente_DIFRA(DELAY_DIFRA);
          }
        Desliga_Motor_Difra();
        Serial.print(0);
        break;
      }
      case 'h': // caso "goto" para trás
      {
        for(int count = 0; count < gotocount; count++)
          {
            tras_DIFRA(DELAY_DIFRA);
          }
        Desliga_Motor_Difra();
        Serial.print(0);
        break;
      }
      case 'j': // caso pré-goto
      {
        delay(100);
        while (Serial.available() > 0) 
        {
          // read the incoming byte:
          incomingByte = Serial.read();
          if (incomingByte != '\r') 
          {      
            value[value_count] = incomingByte;
            value_count++;      
          }
          else 
          {
            value[value_count] = '\0';
            gotocount = atoi(value);          
            value_count = 0;
          }
        }
        Serial.print(gotocount);   
        break;
      }

      
      case 'f': // caso fenda
      {
        countfenda3 = countfenda3+1;
        if (countfenda3 == 1)
        {
          for (int count=0; count<6; count++) 
          {
            tras_FILTRO(DELAY_FILTRO,4);        
          }
          Desliga_Motor_Filtro();
        }
        if (countfenda3 == 2)
        {
          Zera_Filtro();
          Desliga_Motor_Filtro();
          countfenda3 = 0;
        }
        break;
      }


      
      case 'd': // caso desliga motor de passo
      {
        Desliga_Motor_Difra();
        break;
      }
      
      case 'x': // caso intensidade sensor 1
      {
        intensity_IC1 = 0;
          for(int count = 0; count < integration; count++)
          {
            intensity_IC1 = analogRead(IC1) + intensity_IC1;
          }
        intensity_IC1 = intensity_IC1/integration;
        Serial.print(intensity_IC1);
        break;
      }

      case 'z': // caso intensidade sensor 1
      {
        intensity_IC2 = 0;
          for(int count = 0; count < integration; count++)
          {
            intensity_IC2 = analogRead(IC2) + intensity_IC2;
          }
        intensity_IC2 = intensity_IC2/integration;
        Serial.print(intensity_IC2);
        break;
      }
      
      // talvez seja desnecessaria... conferir
      case 'y': // caso inicializa somente a fenda
      {
        Zera_Filtro();
        break;
      }

      case 'u': // caso muda o tipo da lampada para UV
      {
        digitalWrite(TIPO_LAMP, 1);
        break;
      }

      case 'v': // caso muda o tipo da lampada para VIS
      {
        digitalWrite(TIPO_LAMP, 0);
        break;
      }

// case teste
      case 't': // caso teste
      {
       for(int count = 0; count < 660; count++)
        {
          frente_DIFRA(DELAY_DIFRA);
          Serial.print(count);
        }
        break;
      }
// fim case teste
      
    }// fim do switch/case
  }// fim do if(Serial.available())




  
}// fim do void loop()



// Inicializa as Funções //


void Inicia_Difrator()
{
  //Se o motor está na origem: sai da origem e encontra uma nova origem (evitar erro cumulativo)  
  if (digitalRead(ORIGEM_DIFRA) == 1) 
  {
      for (int count=0; count<40; count++) 
      {
        frente_DIFRA(DELAY_DIFRA);        
      }
      Zera_Difrator();
  }
  //Se o motor está fora da origem: busca origem
  else 
  {
      Zera_Difrator();
  }  
}

void Zera_Difrator() {
  while (digitalRead(ORIGEM_DIFRA) == 0) {
    tras_DIFRA(DELAY_DIFRA);
  }
  Desliga_Motor_Difra();
}

void frente_DIFRA(int tempo) {
  
  //Passo 4
  digitalWrite(IN1_DIFRA, 0);
  digitalWrite(IN2_DIFRA, 1);
  digitalWrite(IN3_DIFRA, 0);
  digitalWrite(IN4_DIFRA, 1);
  delay(tempo);

  //Passo 3
  digitalWrite(IN1_DIFRA, 1);
  digitalWrite(IN2_DIFRA, 0);
  digitalWrite(IN3_DIFRA, 0);
  digitalWrite(IN4_DIFRA, 1);
  delay(tempo);

  //Passo 2
  digitalWrite(IN1_DIFRA, 1);
  digitalWrite(IN2_DIFRA, 0);
  digitalWrite(IN3_DIFRA, 1);
  digitalWrite(IN4_DIFRA, 0);
  delay(tempo);
 
  //Passo 1
  digitalWrite(IN1_DIFRA, 0);
  digitalWrite(IN2_DIFRA, 1);
  digitalWrite(IN3_DIFRA, 1);
  digitalWrite(IN4_DIFRA, 0);
  delay(tempo);  
}

void tras_DIFRA(int tempo){
  
  //Passo 1
  digitalWrite(IN1_DIFRA, 1);
  digitalWrite(IN2_DIFRA, 0);
  digitalWrite(IN3_DIFRA, 0);
  digitalWrite(IN4_DIFRA, 1);
  delay(tempo);  

  //Passo 2
  digitalWrite(IN1_DIFRA, 0);
  digitalWrite(IN2_DIFRA, 1);
  digitalWrite(IN3_DIFRA, 0);
  digitalWrite(IN4_DIFRA, 1);
  delay(tempo);

  //Passo 3
  digitalWrite(IN1_DIFRA, 0);
  digitalWrite(IN2_DIFRA, 1);
  digitalWrite(IN3_DIFRA, 1);
  digitalWrite(IN4_DIFRA, 0);
  delay(tempo);

  //Passo 4
  digitalWrite(IN1_DIFRA, 1);
  digitalWrite(IN2_DIFRA, 0);
  digitalWrite(IN3_DIFRA, 1);
  digitalWrite(IN4_DIFRA, 0);
  delay(tempo);
}

void frente_LAMP(int tempo) {
  
  //Passo 4
  digitalWrite(IN1_LAMP, 0);
  digitalWrite(IN2_LAMP, 1);
  digitalWrite(IN3_LAMP, 0);
  digitalWrite(IN4_LAMP, 1);
  delay(tempo);

  //Passo 3
  digitalWrite(IN1_LAMP, 1);
  digitalWrite(IN2_LAMP, 0);
  digitalWrite(IN3_LAMP, 0);
  digitalWrite(IN4_LAMP, 1);
  delay(tempo);

  //Passo 2
  digitalWrite(IN1_LAMP, 1);
  digitalWrite(IN2_LAMP, 0);
  digitalWrite(IN3_LAMP, 1);
  digitalWrite(IN4_LAMP, 0);
  delay(tempo);
 
  //Passo 1
  digitalWrite(IN1_LAMP, 0);
  digitalWrite(IN2_LAMP, 1);
  digitalWrite(IN3_LAMP, 1);
  digitalWrite(IN4_LAMP, 0);
  delay(tempo);  
}

void tras_LAMP(int tempo){
  
  //Passo 1
  digitalWrite(IN1_LAMP, 1);
  digitalWrite(IN2_LAMP, 0);
  digitalWrite(IN3_LAMP, 0);
  digitalWrite(IN4_LAMP, 1);
  delay(tempo);  

  //Passo 2
  digitalWrite(IN1_LAMP, 0);
  digitalWrite(IN2_LAMP, 1);
  digitalWrite(IN3_LAMP, 0);
  digitalWrite(IN4_LAMP, 1);
  delay(tempo);

  //Passo 3
  digitalWrite(IN1_LAMP, 0);
  digitalWrite(IN2_LAMP, 1);
  digitalWrite(IN3_LAMP, 1);
  digitalWrite(IN4_LAMP, 0);
  delay(tempo);

  //Passo 4
  digitalWrite(IN1_LAMP, 1);
  digitalWrite(IN2_LAMP, 0);
  digitalWrite(IN3_LAMP, 1);
  digitalWrite(IN4_LAMP, 0);
  delay(tempo);
}

void Inicia_Filtro()
{
  //Se o motor está na origem: sai da origem e encontra uma nova origem (evitar erro cumulativo)  
  if (digitalRead(ORIGEM_FILTRO) == 1) 
  {
      for (int count=0; count<1; count++) 
      {
        tras_FILTRO(DELAY_FILTRO,4);        
      }
      Zera_Filtro();
  }
  //Se o motor está fora da origem: busca origem
  else 
  {
      Zera_Filtro();
  }  
}

void tras_FILTRO(int tempo, int passos)
{
  int count = 0;
  int out = 0;
  while(count < passos)
  {
    if ((count < passos) && !out) 
    { //Passo 1
      digitalWrite(IN1_FILTRO, 1);
      digitalWrite(IN2_FILTRO, 0);
      digitalWrite(IN3_FILTRO, 0);
      digitalWrite(IN4_FILTRO, 1);
      delay(tempo);
      count = count + 1; 
      out = 1;
    }  
    out = 0;  
    if ((count < passos) && !out) 
    { //Passo 2
      digitalWrite(IN1_FILTRO, 0);
      digitalWrite(IN2_FILTRO, 1);
      digitalWrite(IN3_FILTRO, 0);
      digitalWrite(IN4_FILTRO, 1);
      delay(tempo);
      count = count + 1;
      out = 1;
    }  
    out = 0;
  
    if ((count < passos) && !out) 
    { //Passo 3
      digitalWrite(IN1_FILTRO, 0);
      digitalWrite(IN2_FILTRO, 1);
      digitalWrite(IN3_FILTRO, 1);
      digitalWrite(IN4_FILTRO, 0);
      delay(tempo);
      count = count + 1;
      out = 1;
    }  
    out = 0; 
  
    if ((count < passos) && !out) 
    { //Passo 4
      digitalWrite(IN1_FILTRO, 1);
      digitalWrite(IN2_FILTRO, 0);
      digitalWrite(IN3_FILTRO, 1);
      digitalWrite(IN4_FILTRO, 0);
      delay(tempo);
      count = count + 1;
      out = 1;
    }  
    out = 0;
  }  
}

void Zera_Filtro() 
{
  while (digitalRead(ORIGEM_FILTRO) == 0)
  {
    frente_FILTRO(DELAY_FILTRO, 4);
  }
  Desliga_Motor_Filtro();
}

void Inicia_Lampada()
{
  //Se o motor está na origem: sai da origem e encontra uma nova origem (evitar erro cumulativo)  
  if (digitalRead(ORIGEM_LAMP) == 1) 
  {
      for (int count=0; count<3; count++) 
      {
        frente_LAMP(DELAY_LAMP);        
      }
      Zera_Lampada();
  }
  //Se o motor está fora da origem: busca origem
  else 
  {
      Zera_Lampada();
  }  
}

void Zera_Lampada() 
{
  while (digitalRead(ORIGEM_LAMP) == 0) 
  {
    tras_LAMP(DELAY_LAMP);
  }
  Desliga_Motor_Lamp();
}

void Desliga_Motor_Difra()
{
  digitalWrite(IN1_DIFRA, 0);
  digitalWrite(IN2_DIFRA, 0);
  digitalWrite(IN3_DIFRA, 0);
  digitalWrite(IN4_DIFRA, 0); 
}

void Desliga_Motor_Filtro()
{
  digitalWrite(IN1_FILTRO, 0);
  digitalWrite(IN2_FILTRO, 0);
  digitalWrite(IN3_FILTRO, 0);
  digitalWrite(IN4_FILTRO, 0); 
}

void Desliga_Motor_Lamp()
{
  digitalWrite(IN1_LAMP, 0);
  digitalWrite(IN2_LAMP, 0);
  digitalWrite(IN3_LAMP, 0);
  digitalWrite(IN4_LAMP, 0); 
}

//______________________________________________________________



void Rotina_Filtro(int passos)
{  
  tras_FILTRO(DELAY_FILTRO,passos);    

  Desliga_Motor_Filtro();
}



void frente_FILTRO(int tempo, int passos){
  int count = 0;
  int out = 0;
  while((count < passos) && (digitalRead(ORIGEM_FILTRO) == 0))
  {
    if ((count < passos) && !out && (digitalRead(ORIGEM_FILTRO) == 0)) 
    { //Passo 4
      digitalWrite(IN1_FILTRO, 0);
      digitalWrite(IN2_FILTRO, 1);
      digitalWrite(IN3_FILTRO, 0);
      digitalWrite(IN4_FILTRO, 1);
      delay(tempo);
      count = count + 1; 
      out = 1;
    }
      
    out = 0;  
    
    if ((count < passos) && !out && (digitalRead(ORIGEM_FILTRO) == 0)) 
    { //Passo 3
      digitalWrite(IN1_FILTRO, 1);
      digitalWrite(IN2_FILTRO, 0);
      digitalWrite(IN3_FILTRO, 0);
      digitalWrite(IN4_FILTRO, 1);
      delay(tempo);
      count = count + 1;
      out = 1;
    }  
    
    out = 0;
  
    if ((count < passos) && !out && (digitalRead(ORIGEM_FILTRO) == 0)) 
    { //Passo 2
      digitalWrite(IN1_FILTRO, 1);
      digitalWrite(IN2_FILTRO, 0);
      digitalWrite(IN3_FILTRO, 1);
      digitalWrite(IN4_FILTRO, 0);
      delay(tempo);
      count = count + 1;
      out = 1;
    }  
    
    out = 0; 
  
    if ((count < passos) && !out && (digitalRead(ORIGEM_FILTRO) == 0)) 
    { //Passo 1
      digitalWrite(IN1_FILTRO, 0);
      digitalWrite(IN2_FILTRO, 1);
      digitalWrite(IN3_FILTRO, 1);
      digitalWrite(IN4_FILTRO, 0);
      delay(tempo);
      count = count + 1;
      out = 1;
    }  
    
    out = 0;
  } 
}

void espera(){ // modo espera caso o motor nao tenha energia
  while (digitalRead(fonte) == LOW) {
    delay(100);
  }
}

void Rotina_Lampada(int lamp)
{
  if(lamp == 1)
  {
    if (digitalRead(ORIGEM_LAMP) == 1) 
    {
      for (int count=0; count<8; count++) {
        frente_LAMP(DELAY_LAMP);        
      }
    }
    else
    {
      Zera_Lampada(); 
      for (int count=0; count<8; count++) {
        frente_LAMP(DELAY_LAMP);        
      }   
    }
  }
  else
  {
    if(digitalRead(ORIGEM_LAMP) == 0)
    {
      Zera_Lampada(); 
    }    
  } 
  Desliga_Motor_Lamp();
}

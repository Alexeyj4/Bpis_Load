/*******************************************************
This program was created by the
CodeWizardAVR V2.60 Evaluation
Automatic Program Generator
© Copyright 1998-2012 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 01.10.2012
Author  : 
Company : 
Comments: 


Chip type               : ATtiny13
AVR Core Clock frequency: 9,600000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 16
*******************************************************/

#include <tiny13.h>              
#include <delay.h>

// Declare your global variables here

#define LED PORTB.4

const char corr=1;   //Коррекция при настройке максимума тока (шаг назад)
const int key_pressed_counter_max=15;
const int key_pressed_counter_min=1;
const int main_delay=10;        //задержка в основном цикле программы
unsigned char tuner_start_vol=85;     //начальное значение ШИМ при настройке тока
unsigned char tuner_end_vol=200;    //конечное значение ШИМ при настройке тока  
const int tune_delay=50;   //задержка при настройке тока 
unsigned char adc_vol_1800ma=142;//значение ADC при 1,8А (подбирается опытным путем)
//130=1.7A; 140=1.8A
const unsigned char rise_limit=10;//предел спада тока при настройке на максимум (в значениях ADC)

unsigned char i; //итератор 
int key1_pressed_counter=0;//считает, как долго нажата кнопка 1
int key2_pressed_counter=0;//считает, как долго нажата кнопка 1

unsigned char Iout;  

#define ADC_VREF_TYPE ((1<<REFS0) | (1<<ADLAR))

// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCH;
}

void blink_led()
{
    if(LED==0){LED=1;}else{LED=0;}
}

unsigned char tune_peak()                    // настройка на максимум тока
{
    unsigned char Iout_max=0;      //теущее значение максимального тока
    unsigned char Iout_max_PWMvol=0;     //значение PWM при этом токе
    
     delay_ms(100);   
   
 for(i=OCR0A;i<=tuner_end_vol;i++)
    {   
        blink_led();    //пока настраивается - мигаем светодиодом
        OCR0A=i;
        delay_ms(tune_delay);
        Iout=read_adc(3);        
        if(Iout>Iout_max){Iout_max=Iout;Iout_max_PWMvol=i;}
        if((Iout_max-Iout)>rise_limit){break;}   //прерывание цикла, если пошел спад тока
    } 
    
   if(i>=tuner_end_vol){return 0;}     //не удалось найти пик (спада не было)
    OCR0A=tuner_start_vol;            //установка минимального значения тока,
    delay_ms(100);                          //т.к. у блока питания гистерезис
    OCR0A=Iout_max_PWMvol-corr;        //установка максимального значения тока минус значение коррекции  
   
return Iout_max_PWMvol; //возврат значения PWM, которое было при максимальном токе (либо возврат нуля)           
}

unsigned char tune_peak_or_current(unsigned char adc_vol) //подбор PWM, чтобы на ADC было adc_vol или настройка на максимум тока 
{
    unsigned char Iout_max=0;      //теущее значение максимального тока
    unsigned char Iout_max_PWMvol=0;     //значение PWM при этом токе
    
     delay_ms(100);   
   
 for(i=OCR0A;i<=tuner_end_vol;i++)
    {   
        blink_led();    //пока настраивается - мигаем светодиодом
        OCR0A=i;
        delay_ms(tune_delay);
        Iout=read_adc(3);        
        if(Iout>Iout_max){Iout_max=Iout;Iout_max_PWMvol=i;}
        if((Iout_max-Iout)>rise_limit){break;}   //прерывание цикла, если пошел спад тока     
        if(Iout>=adc_vol){return i;}               //Настроился ток. Возвращаем значение PWM
    }     
    
    OCR0A=tuner_start_vol;            //установка минимального значения тока,
    delay_ms(100);                          //т.к. у блока питания гистерезис
    OCR0A=Iout_max_PWMvol-corr;        //установка максимального значения тока минус значение коррекции  
   
return 0; //возврат нуля, т.к. ток не настроился          
}                              

/*unsigned char tune(unsigned char adc_vol)   //подбор PWM, чтобы на ADC было adc_vol 
{
     OCR0A=tuner_start_vol;
     delay_ms(100);   
      
     if(read_adc(3)>=adc_vol){return 0;}   //ток сразу больше, чем надо настроить - ошибка

    for(i=tuner_start_vol;i<=tuner_end_vol;i++)
    {   
        blink_led();    //пока настраивается - мигаем светодиодом
        OCR0A=i;
        delay_ms(tune_delay);
        Iout=read_adc(3);        
        if(Iout>=adc_vol){return i;}               //Настройка удалась. Возвращаем значение PWM
    }
    
return 0;        //Не удалось настроиться на adc_vol
} */

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Function: Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=Out 
DDRB=(1<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (1<<DDB0);
// State: Bit5=T Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=0 
PORTB=(0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 9600,000 kHz
// Mode: Fast PWM top=0xFF
// OC0A output: Non-Inverted PWM
// OC0B output: Disconnected
// Timer Period: 0,032 ms
// Output Pulse(s):
// OC0A Period: 0,032 ms Width: 0 us
TCCR0A=(1<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (1<<WGM01) | (1<<WGM00);
//(0<<COM0B1) - PWM B off
//(1<<COM0B1) - PWM B off
TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (1<<CS00);

TCNT0=0x00;
OCR0A=85;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// Interrupt on any change on pins PCINT0-5: Off
GIMSK=(0<<INT0) | (0<<PCIE);
MCUCR=(0<<ISC01) | (0<<ISC00);

// Analog Comparator initialization
// Analog Comparator: Off
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIS1) | (0<<ACIS0);
DIDR0=0x00;

// ADC initialization
// ADC Clock frequency: 1000,000 kHz
// ADC Bandgap Voltage Reference: On
// ADC Auto Trigger Source: Free Running
// Only the 8 most significant bits of
// the AD conversion result are used
// Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
DIDR0|=(0<<ADC0D) | (0<<ADC2D) | (0<<ADC3D) | (0<<ADC1D);
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (1<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
 
if(tune_peak_or_current(adc_vol_1800ma))
{LED=1;}else{LED=0;}   //Настройка на заданный ток удалась - включаем светодиод

while (1)
      {
      // Place your code here

            if(PINB.1==0){key1_pressed_counter=0;}
            if(PINB.1==1){key1_pressed_counter++;}
            if(key1_pressed_counter==key_pressed_counter_max){key1_pressed_counter=0;}
            
            
            if(PINB.2==0){key2_pressed_counter=0;}
            if(PINB.2==1){key2_pressed_counter++;}
            if(key2_pressed_counter==key_pressed_counter_max){key2_pressed_counter=0;}
            
                          
           delay_ms(main_delay);
          
      
            
           if((key1_pressed_counter==key_pressed_counter_min)&&(key2_pressed_counter==0))    //если кнопка 1, то увеличение тока
           {       
                LED=1;
                delay_ms(5);
                OCR0A++;
                LED=0;                                        
           }                    
           

          if((key2_pressed_counter==key_pressed_counter_min)&&(key1_pressed_counter==0))     //если кнопка 2, то уменьшение тока
           {    
                LED=1;
                delay_ms(5);
                OCR0A--;
                LED=0;                              
           } 
           
          if((PINB.1==1)&&(PINB.2==1))     //если нажаты обе кнопки, то настройка на макс тока
          { 
                LED=0;
                if(tune_peak()){LED=1;}else{LED=0;};
          } 
          
            
      }
}

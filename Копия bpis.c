#include <tiny13.h>              
#include <delay.h>
#define LED PORTB.4
const int key_pressed_counter_max=15;
const int key_pressed_counter_min=1;
const int main_delay=10;        //�������� � �������� ����� ���������
unsigned char tuner_start_vol=85; 
unsigned char tuner_end_vol=180;  
const int tune_delay=50;   //�������� ��� ��������� ���� 
unsigned char adc_vol_1800ma=138;//�������� ADC ��� 1,8� (����������� ������� �����)
const unsigned char rise_limit=10;//������ ����� ���� ��� ��������� �� �������� (� ��������� ADC)
unsigned char i; //�������� 
int key1_pressed_counter=0;//�������, ��� ����� ������ ������ 1
int key2_pressed_counter=0;//�������, ��� ����� ������ ������ 1

unsigned char Iout;  

#define ADC_VREF_TYPE ((1<<REFS0) | (1<<ADLAR))
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
delay_us(10);
ADCSRA|=(1<<ADSC);
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCH;
}
void blink_led()
{
    if(LED==0){LED=1;}else{LED=0;}
}
unsigned char tune_peak()                    // ��������� �� �������� ����
{
    unsigned char Iout_max=0;      //������ �������� ������������� ����
    unsigned char Iout_max_PWMvol=0;     //�������� PWM ��� ���� ����    
     delay_ms(1000);      
    for(i=tuner_start_vol;i<=tuner_end_vol;i++)
    {   
        blink_led();    //���� ������������� - ������ �����������
        OCR0A=i;
        delay_ms(tune_delay);
        Iout=read_adc(3);        
        if(Iout>Iout_max){Iout_max=Iout;Iout_max_PWMvol=i;}
        if((Iout_max-Iout)>rise_limit){break;}   //���������� �����, ���� ����� ���� ����
    } 
   if(i>tuner_end_vol){return 0;}     //�� ������� ����� ��� (����� �� ����)
    OCR0A=Iout_max_PWMvol;        //��������� ������������� �������� ����  
   
return Iout_max_PWMvol; //������� �������� PWM, ������� ���� ��� ������������ ���� (���� ������� ����)           
}
unsigned char tune(unsigned char adc_vol)   //������ PWM, ����� �� ADC ���� adc_vol 
{
     OCR0A=tuner_start_vol;
     delay_ms(1000);  
     if(read_adc(3)>=adc_vol){return 0;}   //��� ����� ������, ��� ���� ��������� - ������
    for(i=tuner_start_vol;i<=tuner_end_vol;i++)
    {   
        blink_led();    //���� ������������� - ������ �����������
        OCR0A=i;
        delay_ms(tune_delay);
        Iout=read_adc(3);        
        if(Iout>=adc_vol){return i;}               //��������� �������. ���������� �������� PWM
    }   
return 0;        //�� ������� ����������� �� adc_vol
}
void main(void)
{
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif
DDRB=(1<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (1<<DDB0);
PORTB=(0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
TCCR0A=(1<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (1<<WGM01) | (1<<WGM00);
TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0A=85;
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
GIMSK=(0<<INT0) | (0<<PCIE);
MCUCR=(0<<ISC01) | (0<<ISC00);
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIS1) | (0<<ACIS0);
DIDR0=0x00;
DIDR0|=(0<<ADC0D) | (0<<ADC2D) | (0<<ADC3D) | (0<<ADC1D);
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (1<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0); 
if(tune_peak())
{LED=1;}   //��������� �� �������� ���� ������� - �������� ���������
while (1)
      {
            if(PINB.1==0){key1_pressed_counter=0;}
            if(PINB.1==1){key1_pressed_counter++;}
            if(key1_pressed_counter==key_pressed_counter_max){key1_pressed_counter=0;}
                        
            if(PINB.2==0){key2_pressed_counter=0;}
            if(PINB.2==1){key2_pressed_counter++;}
            if(key2_pressed_counter==key_pressed_counter_max){key2_pressed_counter=0;}
               
           delay_ms(main_delay);
            
           if((key1_pressed_counter==key_pressed_counter_min)&&(key2_pressed_counter==0))    //���� ������ 1, �� ���������� ����
           {       
                LED=1;
                delay_ms(5);
                OCR0A++;
                LED=0;                                        
           } 
          if((key2_pressed_counter==key_pressed_counter_min)&&(key1_pressed_counter==0))     //���� ������ 2, �� ���������� ����
           {    
                LED=1;
                delay_ms(5);
                OCR0A--;
                LED=0;                              
           }   
          if((PINB.1==1)&&(PINB.2==1))     //���� ������ ��� ������, �� ��������� �� 1.8�
          { 
                LED=0;
                if(tune(adc_vol_1800ma)){LED=1;};
          }       
      }
}

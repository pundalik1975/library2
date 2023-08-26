/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 9/11/2017
Author  : 
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 12.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega16.h>



#define digit1() PORTC.5=1
#define digit2() PORTC.6=1
#define digit3() PORTC.7=1
#define digit4() PORTC.4=1
#define digit5() PORTC.2=1
#define digit6() PORTC.3=1
#define digit7() PORTC.1=1
#define digit8() PORTC.0=1
#define digit9() PORTD.7 = 1


#define relay PORTD.1


void clear_display(void)
{
PORTA =0xff;
PORTC = 0x00;
PORTD.7= 0; 

}

unsigned short int led_status;
                                  
#define all_led_off() led_status = 0xff;
#define led1_on() led_status &= 0xfe
#define led2_on() led_status &= 0xfd
#define led3_on() led_status &= 0xfb
#define led4_on() led_status &= 0xf7
#define led5_on() led_status &= 0xef
#define led6_on() led_status &= 0xdf
#define led7_on() led_status &= 0xbf
#define led8_on() led_status &= 0x7f
#define led1_off() led_status |= 0x01
#define led2_off() led_status |= 0x02
#define led3_off() led_status |= 0x04
#define led4_off() led_status |= 0x08
#define led5_off() led_status |= 0x10
#define led6_off() led_status |= 0x20
#define led7_off() led_status |= 0x40
#define led8_off() led_status |= 0x80

#define key1 PIND.4
#define key2 PIND.5
#define key3 PIND.6
#define key4 PIND.3
#define key5 PIND.4
#define key6 PIND.4


void led_check(void)
{    
all_led_off();
if (relay) led1_off();
else led1_on();
if (!relay) led2_off();
else led2_on();
}


// Declare your global variables here
//                              0     1     2   3    4    5    6    7     8    9   10    11   12   13   14   15   16   17   18   19   20   21   22   23   24   25   26   27   28   29   30   31   32   33  34
//                              0     1     2   3    4    5    6    7     8    9    a    b    c    d    e    f    g    h    j    k    l    m    n    o    p    r    t    u    w    y    z    .    -   
unsigned char segment_table[]= {0x14,0xd7,0x4c,0x45,0x87,0x25,0x24,0x57,0x04,0x05,0x06,0xa4,0x3c,0xc4,0x2c,0x2e,0x34,0x86,0xd5,0x26,0xbc,0x66,0xe6,0xe4,0x0e,0xee,0xac,0xf4,0x74,0x85,0x10,0xfb,0xef,0xff};


short int display_buffer[9];

bit set_fl,sec_fl,blink_flag,blinking;
int blink_digit;
short int dummy[1] = {0};
short int dummy2[1] = {0}; 
unsigned int display_count;                                                  
int ontime,offtime;
short int message_set[]= {23,24,32,01,23,24,32,02,05,25,0,2,27,22,0,2,05,25,0,3,27,22,0,3,05,25,0,4,27,22,0,4,05,25,0,5,27,22,0,5,05,25,0,6,27,22,0,6,05,25,0,7,27,22,0,7,05,25,0,8,27,22,0,8,05,25,0,9,27,22,0,9,05,25,1,0,27,22,1,0,05,25,1,1,27,22,1,1,05,25,1,2,27,22,1,2,05,25,1,3,27,22,1,3,05,25,1,4,27,22,1,4,05,25,1,5,27,22,1,5,05,25,1,6,27,22,1,6};  //sp01/tm01 to sp16/tm16
int set[10];
short int set_item,key_count,key_rst_cnt,set_count;
eeprom int ee_set[] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};    //uncomment for pt100 0.1 default
bit key1_old=1,key2_old=1,key3_old=1,key4_old=1;
bit on_fl;
bit min_fl;
int min_cnt;



// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Reinitialize Timer1 value
TCNT1H=0x48E5 >> 8;
TCNT1L=0x48E5 & 0xff;
// Place your code here
sec_fl=1;
blinking = ~blinking;
min_cnt++;
if(min_cnt>=60)
{
min_cnt =0;
min_fl =1;
}
}


void display_put(int up_display, int low_display,int status,short int* message1,short int* message2)
{
if (status ==0) 
        {
        if (up_display <0)
        {                
        up_display = -up_display;
        up_display%=1000;
        display_buffer[0]= 31;
        }
        else
        {                                              
        display_buffer[0]=up_display/1000;
        up_display%=1000;
        }
        display_buffer[1]=up_display/100;
        up_display%=100;
        display_buffer[2]=up_display/10;
        up_display%=10;
        display_buffer[3]=up_display;

        if (low_display <0)
        {                
        low_display = -low_display;
        low_display%=1000;
        display_buffer[4]= 31;
        }
        else
        {                                              
        display_buffer[4]=low_display/1000;
        low_display%=1000;
        }
        display_buffer[5]=low_display/100;
        low_display%=100;
        display_buffer[6]=low_display/10;
        low_display%=10;
        display_buffer[7]=low_display;
        }
else if (status ==1)
        {   
        message1 = message1 + (up_display *4);
        display_buffer[0]=*message1;
        message1++;
        display_buffer[1]=*message1;
        message1++;
        display_buffer[2]=*message1;
        message1++;
        display_buffer[3]=*message1;
        if (low_display <0)
        {                
        low_display = -low_display;
        low_display%=1000;
        display_buffer[4]= 31;
        }
        else
        {                                              
        display_buffer[4]=low_display/1000;
        low_display%=1000;
        }
        display_buffer[5]=low_display/100;
        low_display%=100;
        display_buffer[6]=low_display/10;
        low_display%=10;
        display_buffer[7]=low_display;
        }
else if (status ==2)
        {
        message1 = message1 + (up_display *4);
        display_buffer[0]=*message1;
        message1++;
        display_buffer[1]=*message1;
        message1++;
        display_buffer[2]=*message1;
        message1++;
        display_buffer[3]=*message1;
        message2 = message2 + (low_display * 4);
        display_buffer[4]=*message2;
        message2++;
        display_buffer[5]=*message2;
        message2++;
        display_buffer[6]=*message2;
        message2++;
        display_buffer[7]=*message2;
        }   
if (status ==3) 
        {
        if (up_display <0)
        {                
        up_display = -up_display;
        up_display%=1000;
        display_buffer[0]= 31;
        }
        else
        {                                              
        display_buffer[0]=up_display/1000;
        up_display%=1000;
        }
        display_buffer[1]=up_display/100;
        up_display%=100;
        display_buffer[2]=up_display/10;
        up_display%=10;
        display_buffer[3]=up_display;

        message2 = message2 + (low_display * 4);
        display_buffer[4]=*message2;
        message2++;
        display_buffer[5]=*message2;
        message2++;
        display_buffer[6]=*message2;
        message2++;
        display_buffer[7]=*message2;
        }

// code added to blank the unused 0s


}


void display_out(short int count2)
{
int asa;
clear_display();
asa = display_buffer[count2];
asa = segment_table[asa];
if (count2 == (7-blink_digit))
{
if (blink_flag && blinking)
PORTA =0xff;
else
PORTA = asa;
}
else
PORTA = asa;//decimal point for upper display
//if ((count2 == 6) && config_fl && (config[0]==0)&&((config_item==2)||(config_item==4)||(config_item==7)||(config_item==8)))PORTC.0=0;
switch(count2)
        {
        case 0:  digit1();
        break;
        case 1:  digit2();
                if (!set_fl) PORTA.2 =0;
        break;
        case 2:  
                digit3();
        break;
        case 3:if (on_fl && !set_fl) PORTA.2 =blinking; 
        
         digit4();
        break;
        case 4:  digit5();
        break;
        case 5:  digit6();
                PORTA.2 =0;
        break;
        case 6: //if (!set_fl && !config_fl && (config[0] ==0)&& !toggle_fl) PORTC.0 =0; 
                //if (set_fl && !config_fl && (config[0]==0) && (set_item ==0)) PORTC.0 =0;
                //if (!set_fl && config_fl && (config[0]==0))
                 //   {
                  //  if ((config_item ==1)||(config_item ==3) || (config_item==6)||(config_item==7)) PORTC.0=0;
                  //  }
                digit7();

        break;
        case 7: if(!on_fl && !set_fl) PORTA.2 =blinking; 
        
                digit8();
        break;
        case 8: PORTA = led_status;        
                digit9();
        break;
        }

//if (config_fl && !set_fl) display_put(config_item,config[config_item],1,message_config,dummy);
//if (!config_fl && set_fl && !calib) display_put(0,set[0],1,message_set,dummy);

}

void display_check(void)
{
    if (set_fl)
    {
    display_put(set_item,set[set_item],1,message_set,dummy);        
    }
    else
    {
    display_put(ontime,offtime,0,dummy,dummy2);
    }
}

void increment_value(int* value,int low_limit,int high_limit,short int power)
{
int x,y;
int a;
int b=1;
for (a=0;a<power;a++) b = b*10;
*value = *value + b;
// added to increment 100th place if lower digits crosses 59(99:59)
x = *value /100; //higher digit
y = *value%100; //lower digit
if (y >= 60)
{
x++;
y=0;
*value = (x *100)+y;
}
//
if (*value < low_limit) *value = low_limit;
if (*value >= high_limit) *value = high_limit;
} 

void decrement_value(int* value,int low_limit,int high_limit,short int power)
{
int x,y;
int a;
int b=1;
for (a=0;a<power;a++) b = b*10;
*value = *value- b;
x = *value /100;
y = *value %100;
if (y >=60)
{
y=59;
*value = (x*100) +y;

}

if (*value < low_limit) *value = low_limit;
if (*value >= high_limit) *value = high_limit;
} 

void ent_check(void)
{

    if (set_fl)
    {   
    blink_digit =0;
    ee_set[set_item] = set[set_item];
    if(set_item >= 1)
            {
            set_fl =0;
            set_item =0;
            blink_digit =0;
            blink_flag =0;
            }
            else
            {
            ee_set[set_item] = set[set_item];
            set_item++;
            if (set_item >1) set_item =0;
            }
        display_put(set_item,set[set_item],1,message_set,dummy);
  
    }
}

void inc_check(void)
{
    if(set_fl)
    {
    switch (set_item)
    {
    case 0: increment_value(&set[0],1,9959,blink_digit);    //temp1
               break;
    case 1: increment_value(&set[1],1,9959,blink_digit);   //time
            break;
    }
    }
 
}

void dec_check(void)
{
    if(set_fl)
    {
    switch (set_item)
    {
    case 0: decrement_value(&set[0],1,9959,blink_digit);    //temp1
            
            break;
    case 1: decrement_value(&set[1],1,9959,blink_digit);   //time
            break;
    }
    }
             

}

void shf_check(void)
{

    if(set_fl)
    {
    if (blink_flag)
    blink_digit++;
    if (blink_digit > 3)
    blink_digit=0;
    } 
}



void key_check()
{
     key1 = key2 = key3 = key4 = 1;
      key_count++;
 if (key_count >=100)
    { 
      key_count=0;     
      if (!key1 && key1_old)
      {
      ent_check();
      key_rst_cnt =0;
      }
      if (!key2 && key2_old)
      {
      inc_check();   
      key_rst_cnt=0;      
      }
      if (!key3 && key3_old)
      {
      dec_check();
      key_rst_cnt =0;
      }
      if (!key4 && key4_old)
      {
      shf_check();
      key_rst_cnt=0;
      }
      key1_old = key1;
      key2_old = key2;
      key3_old = key3;
      key4_old = key4;
     } 
}

void check_set(void)
{
if (!key6)
{
set_count++;
if (set_count >=5000)
{
set_count =0;
if(!set_fl)
{
set[0] = ee_set[0];
display_put(0,set[0],1,message_set,dummy);
set_fl =1;
blink_digit =0;
blink_flag=1;
}
}

}
else
set_count =0;
}



void process_check(void)
{
    if (on_fl)
    {
    relay =0;
    increment_value(&ontime,0,9959,0);
        if (ontime >= set[0])
        {
        relay =1;
        ontime=0;
        offtime =0;
        on_fl=0;
        }
    }
    else
    {
    relay =1;
    increment_value(&offtime,0,9959,0);
        if (offtime >=set[1])
        {
        relay =0;
        offtime=0; 
        ontime =0;
        on_fl =1;
        }
    
    }


}

void eeprom_transfer(void)
{
set[0] = ee_set[0];
set[1] = ee_set[1];
}

void init(void)
{
// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
// State: Bit7=1 Bit6=1 Bit5=1 Bit4=1 Bit3=1 Bit2=1 Bit1=1 Bit0=1 
PORTA=(1<<PORTA7) | (1<<PORTA6) | (1<<PORTA5) | (1<<PORTA4) | (1<<PORTA3) | (1<<PORTA2) | (1<<PORTA1) | (1<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=P Bit6=P Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=P 
PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);

// Port C initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out 
DDRD=(1<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=0 Bit6=P Bit5=P Bit4=P Bit3=P Bit2=1 Bit1=1 Bit0=1 
PORTD=(0<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 46.875 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 1 s
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x48;
TCNT1L=0xE5;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

}

void main(void)
{
// Declare your local variables here
init();

eeprom_transfer();
// Global enable interrupts
#asm("sei")
on_fl =1;
relay =0;
while (1)
      {  
      if (min_fl)
      {
      min_fl=0;
      process_check();
      }
      
      // Place your code here
            display_check();
        //display_put(timer1,timer2,0,dummy,dummy2);                       //**
      check_set();      
      display_out(display_count);
      display_count++; 
      led_check();
      if(display_count >=9) 
      {
      display_count =0;  
      key_check();
      }
      }
}

/* REXX ***************************************************************
* Decode Memory structure of  RS-232 Plug Definition
* Not sure if I understood it completely :-) Open for corrections
* You never stop learning (as long as you live)
* 03.08.2012 Walter Pachl
**********************************************************************/
Call decode 'ABC'
Call decode 'XY'
Exit

decode:
  Parse Arg c
  cb=c2b(c)
  If length(cb)=24 Then Do
    Parse Var cb,
     /*    1 - PG  */ Protective ground      +1,
     /* 3  2 - TD  */ Transmitted_data       +1,
     /* 2  3 - RD  */ Received_data          +1,
     /* 7  4 - RTS */ Request_to_send        +1,
     /* 8  5 - CTS */ Clear_to_send          +1,
     /* 6  6 - DSR */ Data_set_ready         +1,
     /* 5  7 - SG  */ Signal_ground          +1,
     /* 1  8 - CD  */ Carrier_detect         +1,
     /*    9 - +   */ plus_voltage           +1,
     /*   10 - -   */ minus_voltage          +1,
     /*   11 -     */ .                      +1,
     /*   12 - SCD */ Secondary_CD           +1,
     /*   13 - SCS */ Secondary_CTS          +1,
     /*   14 - STD */ Secondary_TD           +1,
     /*   15 - TC  */ Transmit_clock         +1,
     /*   16 - SRD */ Secondary_RD           +1,
     /*   17 - RC  */ Receiver_clock         +1,
     /*   18 -     */ .                      +1,
     /*   19 - SRS */ Secondary_RTS          +1,
     /* 4 20 - DTR */ Data_terminal_ready    +1,
     /*   21 - SQD */ Signal_quality_detector+1,
     /* 9 22 - RI  */ Ring_indicator         +1,
     /*   23 - DRS */ Data_rate_select       +1,
     /*   24 - XTC */ External_clock         +1
    Say '24 bins:' cb
    Say ' 1 - PG  Protective ground       ='Protective ground
    Say ' 2 - TD  Transmitted data        ='Transmitted_data
    Say ' 3 - RD  Received data           ='Received_data
    Say ' 4 - RTS Request to send         ='Request_to_send
    Say ' 5 - CTS Clear to send           ='Clear_to_send
    Say ' 6 - DSR Data set ready          ='Data_set_ready
    Say ' 7 - SG  Signal ground           ='Signal_ground
    Say ' 8 - CD  Carrier detect          ='Carrier_detect
    Say ' 9 - +   plus voltage            ='plus_voltage
    Say '10 - -   minus voltage           ='minus_voltage
    Say ' '
    Say '12 - SCD Secondary CD            ='Secondary_CD
    Say '13 - SCS Secondary CTS           ='Secondary_CTS
    Say '14 - STD Secondary TD            ='Secondary_TD
    Say '15 - TC  Transmit clock          ='Transmit_clock
    Say '16 - SRD Secondary RD            ='Secondary_RD
    Say '17 - RC  Receiver clock          ='Receiver_clock
    Say ' '
    Say '19 - SRS Secondary RTS           ='Secondary_RTS
    Say '20 - DTR Data terminal ready     ='Data_terminal_ready
    Say '21 - SQD Signal quality detector ='Signal_quality_detector
    Say '22 - RI  Ring indicator          ='Ring_indicator
    Say '23 - DRS Data rate select        ='Data_rate_select
    Say '24 - XTC External hlock          ='External_clock
    End
  Else Do
    Parse Var cb,
    /* 1  8 - CD  */ Carrier_detect         +1,
    /* 2  3 - RD  */ Received_data          +1,
    /* 3  2 - TD  */ Transmitted_data       +1,
    /* 4 20 - DTR */ Data_terminal_ready    +1,
    /* 5  7 - SG  */ Signal_ground          +1,
    /* 6  6 - DSR */ Data_set_ready         +1,
    /* 7  4 - RTS */ Request_to_send        +1,
    /* 8  5 - CTS */ Clear_to_send          +1,
    /* 9 22 - RI  */ Ring_indicator         +1
    Say ' '
    Say '9-bin:' left(cb,9)
    Say ' 1 CD   Carrier detect      ='Carrier_detect
    Say ' 2 RD   Received data       ='Received_data
    Say ' 3 TD   Transmitted data    ='Transmitted_data
    Say ' 4 DTR  Data terminal ready ='Data_terminal_ready
    Say ' 5 SG   Signal ground       ='Signal_ground
    Say ' 6 DSR  Data set ready      ='Data_set_ready
    Say ' 7 RTS  Request to send     ='Request_to_send
    Say ' 8 CTS  Clear to send       ='Clear_to_send
    Say ' 9 RI   Ring indicator      ='Ring_indicator
    End
  Return
c2b: Procedure
/* REXX ***************************************************************
* c2b Convert a character string to a bit string
* 03.08.2012 Walter Pachl
**********************************************************************/
Parse Arg c
x=c2x(c)
res=''
Do While x<>''
  Parse Var x hb +1 x
  Select
    When hb='0' Then bs='0000'
    When hb='1' Then bs='0001'
    When hb='2' Then bs='0010'
    When hb='3' Then bs='0011'
    When hb='4' Then bs='0100'
    When hb='5' Then bs='0101'
    When hb='6' Then bs='0110'
    When hb='7' Then bs='0111'
    When hb='8' Then bs='1000'
    When hb='9' Then bs='1001'
    When hb='A' Then bs='1010'
    When hb='B' Then bs='1011'
    When hb='C' Then bs='1100'
    When hb='D' Then bs='1101'
    When hb='E' Then bs='1110'
    When hb='F' Then bs='1111'
    End
  res=res||bs
  End
Return res

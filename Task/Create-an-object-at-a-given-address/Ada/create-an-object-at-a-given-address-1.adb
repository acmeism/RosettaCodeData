type IO_Port is mod 2**8; -- One byte
Device_Port : type IO_Port;
for Device_Port'Address use 16#FFFF_F000#;

$$ MODE TUSCRIPT,{}
string="alphaBETA"
lowercase =EXCHANGE(string," {&a} {-0-} ")
uppercase1=EXCHANGE(string," {&a} {-0+} ")
uppercase2=CAPS    (string)
PRINT lowercase
PRINT uppercase1
PRINT uppercase2

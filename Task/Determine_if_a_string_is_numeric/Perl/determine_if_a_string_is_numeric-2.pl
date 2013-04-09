if (/\D/)            { print "has nondigits\n" }
if (/^\d+\z/)         { print "is a whole number\n" }
if (/^-?\d+\z/)       { print "is an integer\n" }
if (/^[+-]?\d+\z/)    { print "is a +/- integer\n" }
if (/^-?\d+\.?\d*\z/) { print "is a real number\n" }
if (/^-?(?:\d+(?:\.\d*)?&\.\d+)\z/) { print "is a decimal number\n" }
if (/^([+-]?)(?=\d&\.\d)\d*(\.\d*)?([Ee]([+-]?\d+))?\z/)
                     { print "a C float\n" }

# Project : Decision tables

see "The printer does not print (Y or N) "
give notprinting
see "A red light is upper(flashing) (Y or N) "
give flashing
see "The printer is unrecognized (Y or N) "
give notrecognized

if upper(notprinting) = "Y" and upper(flashing) = "Y" and upper(notrecognized) = "Y"
   see "Check the printer-computer cable" + nl
   see "Ensure printer software is installed" + nl
   see "Check/replace ink"
elseif upper(notprinting) = "Y" and upper(flashing) = "Y" upper(notrecognized) = "N"
        see "Check/replace ink" + nl
        see "Check for paper jam" + nl
elseif upper(notprinting) = "Y" and  upper(flashing) = "N" and upper(notrecognized) = "Y"
        see "Check the power cable"
        see "Check the printer-computer cable" + nl
        see "Ensure printer software is installed" + nl
elseif upper(notprinting) = "Y" and upper(flashing) = "N" and upper(notrecognized) = "N"
        see "Check for paper jam" + nl
elseif upper(notprinting) = "N" and upper(flashing) = "Y" and upper(notrecognized) = "Y"
        see "Ensure printer software is installed" + nl
        see "Check/replace ink" + nl
elseif upper(notprinting) = "N" and upper(flashing) = "Y" and upper(notrecognized) = "N"
        see "Check/replace ink" + nl
elseif upper(notprinting) = "N" and upper(flashing) = "N" and upper(notrecognized) = "Y"
        see "Ensure printer software is installed" + nl
elseif upper(notprinting) = "N" and upper(flashing) = "N" and upper(notrecognized) = "N"
        see "no action found" + nl
else
        see "invalid input: " + upper(notprinting) + " " + upper(flashing) + " " + upper(notrecognized) + nl
ok

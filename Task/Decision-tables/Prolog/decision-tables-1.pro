%!  troubleshoot(?PrinterPrints, ?LightIsFlashing, ?RecognisedByComputer, ?Advice) is nondet.
troubleshoot(false, false, false, 'check the power cable').
troubleshoot(false,     _, false, 'check the printer-computer cable').
troubleshoot(    _,     _, false, 'ensure the printer software is installed').
troubleshoot(false,  true,     _, 'check/replace ink').
troubleshoot( true,  true,  true, 'check/replace ink').
troubleshoot(false,     _,  true, 'check for paper jam').

DecisionTable create printerDiagnosisTable {
    "Printer does not print"
    "A red light is flashing"
    "Printer is unrecognised"
} {
    "Check the power cable"			{0 0 1}
    "Check the printer-computer cable"		{1 0 1}
    "Ensure printer software is installed"	{1 0 1 0 1 0 1}
    "Check/replace ink"				{1 1 0 0 1 1}
    "Check for paper jam"			{0 1 0 1}
}
printerDiagnosisTable consult

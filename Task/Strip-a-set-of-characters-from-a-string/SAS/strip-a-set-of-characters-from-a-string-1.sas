%let string=She was a soul stripper. She took my heart!;
%let chars=aei;
%let stripped=%sysfunc(compress("&string","&chars"));
%put &stripped;

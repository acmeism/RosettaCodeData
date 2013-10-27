%MACRO palindro(string, ignorewhitespace);
  DATA _NULL_;
    %IF %UPCASE(&ignorewhitespace)=Y %THEN %DO;
/* The arguments of COMPRESS (sp) ignore blanks and puncutation */
/* We take the string and record it in reverse order using the REVERSE function. */
      %LET rev=%SYSFUNC(REVERSE(%SYSFUNC(COMPRESS(&string,,sp))));
      %LET string=%SYSFUNC(COMPRESS(&string.,,sp));
    %END;

    %ELSE %DO;
      %LET rev=%SYSFUNC(REVERSE(&string));
    %END;
    /*%PUT rev=&rev.;*/
    /*%PUT string=&string.;*/

/* Here we determine if the string and its reverse are the same. */
    %IF %UPCASE(&string)=%UPCASE(&rev.) %THEN %DO;
      %PUT TRUE;
    %END;
    %ELSE %DO;
      %PUT FALSE;
    %END;
  RUN;
%MEND;

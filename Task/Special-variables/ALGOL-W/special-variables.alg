% the Algol W standard environment includes the following standard variables: %

integer                I_W          % field width for integer output %
integer                R_W          % field width for real output %
integer                R_D          % number of decimal places for real output %
string(1)              R_FORMAT     % format for real output:
                                          S - "scaled" normalised mantissa with exponent
                                          A - "aligned" fixed point format
                                          F - "free" either scaled or aligned as appropriate
                                                     for the value and field width
                                    %
integer                S_W          % separator width - number of spaces following non-string output items %
integer                MAXINTEGER   % largest integer value %
real                   EPSILON      % largest positive real number such that 1 + epsilon = 1 %
long real              LONGEPSILON  % largest positive long real number such that 1 + longepsilon = 1 %
long real              MAXREAL      % largest real number %
long real              PI           % approximation to pi %

% the following reference(EXCEPTION) variables control how errors are handled:
    ENDFILE                         - end-of-file
    OVFL                            - overflow
    UNFL                            - underflow
    DIVZERO                         - division by zero
    INTOVFL                         - integer overflow
    INTDIVZERO                      - integer division by zero or modulo 0
    SQRTERR                         - invalid SQRT parameter
    EXPERR                          - invalid EXP parameter
    LNLOGERR                        - invalid LN or LOG parameter
    SINCOSERR                       - invalid SIN or COS parameter

The EXCEPTION record is defined as follows:

record    EXCEPTION( logical    XCPNOTED      - true if the exception has occurred
                   ; integer    XCPLIMIT      - number of times the exception can occur
                                                before the program terminates
                              , XCPACTION     - if the program continues, controls how to
                                                replace the erroneous value
                   ; logical    XCPMARK       - true if an error message should be printed
                                                even if the program continues
                   ; string(64) XCPMSG        - message to describe the exception
                   )

if the relevant EXCEPTION variable is null, the exception is ignored,
otherwise it is processed according to the settings of XCPLIMIT etc.
%

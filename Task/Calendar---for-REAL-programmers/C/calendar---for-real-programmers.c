/* UPPER CASE ONLY VERSION OF THE ORIGINAL CALENDAR.C, CHANGES MOSTLY TO AVOID NEEDING #INCLUDES */
/* ERROR MESSAGES GO TO STDOUT TO SLIGHTLY SIMPLIFY THE I/O HANDLING                             */
/* WHEN COMPILING THIS, THE COMMAND LINE SHOULD SPECIFY -D OPTIONS FOR THE FOLLOWING WORDS:      */
/*    STRUCT, VOID, INT, CHAR, CONST, MAIN, IF, ELSE, WHILE, FOR, DO, BREAK, RETURN, PUTCHAR     */
/* THE VALUE OF EACH MACRO SHOULD BE THE WORD IN LOWER-CASE                                      */

INT PUTCHAR(INT);

INT WIDTH = 80, YEAR = 1969;
INT COLS, LEAD, GAP;

CONST CHAR *WDAYS[] = { "SU", "MO", "TU", "WE", "TH", "FR", "SA" };
STRUCT MONTHS {
    CONST CHAR *NAME;
    INT DAYS, START_WDAY, AT;
} MONTHS[12] = {
    { "JANUARY",    31, 0, 0 },
    { "FEBRUARY",    28, 0, 0 },
    { "MARCH",    31, 0, 0 },
    { "APRIL",    30, 0, 0 },
    { "MAY",    31, 0, 0 },
    { "JUNE",    30, 0, 0 },
    { "JULY",    31, 0, 0 },
    { "AUGUST",    31, 0, 0 },
    { "SEPTEMBER",    30, 0, 0 },
    { "OCTOBER",    31, 0, 0 },
    { "NOVEMBER",    30, 0, 0 },
    { "DECEMBER",    31, 0, 0 }
};

VOID SPACE(INT N) { WHILE (N-- > 0) PUTCHAR(' '); }
VOID PRINT(CONST CHAR * S){ WHILE (*S != '\0') { PUTCHAR(*S++); } }
INT  STRLEN(CONST CHAR * S)
{
   INT L = 0;
   WHILE (*S++ != '\0') { L ++; };
RETURN L;
}
INT ATOI(CONST CHAR * S)
{
    INT I = 0;
    INT SIGN = 1;
    CHAR C;
    WHILE ((C = *S++) != '\0') {
        IF (C == '-')
            SIGN *= -1;
        ELSE {
            I *= 10;
            I += (C - '0');
        }
    }
RETURN I * SIGN;
}

VOID INIT_MONTHS(VOID)
{
    INT I;

    IF ((!(YEAR % 4) && (YEAR % 100)) || !(YEAR % 400))
        MONTHS[1].DAYS = 29;

    YEAR--;
    MONTHS[0].START_WDAY
        = (YEAR * 365 + YEAR/4 - YEAR/100 + YEAR/400 + 1) % 7;

    FOR (I = 1; I < 12; I++)
        MONTHS[I].START_WDAY =
            (MONTHS[I-1].START_WDAY + MONTHS[I-1].DAYS) % 7;

    COLS = (WIDTH + 2) / 22;
    WHILE (12 % COLS) COLS--;
    GAP = COLS - 1 ? (WIDTH - 20 * COLS) / (COLS - 1) : 0;
    IF (GAP > 4) GAP = 4;
    LEAD = (WIDTH - (20 + GAP) * COLS + GAP + 1) / 2;
        YEAR++;
}

VOID PRINT_ROW(INT ROW)
{
    INT C, I, FROM = ROW * COLS, TO = FROM + COLS;
    SPACE(LEAD);
    FOR (C = FROM; C < TO; C++) {
        I = STRLEN(MONTHS[C].NAME);
        SPACE((20 - I)/2);
        PRINT(MONTHS[C].NAME);
        SPACE(20 - I - (20 - I)/2 + ((C == TO - 1) ? 0 : GAP));
    }
    PUTCHAR('\012');

    SPACE(LEAD);
    FOR (C = FROM; C < TO; C++) {
        FOR (I = 0; I < 7; I++) {
            PRINT(WDAYS[I]);
            PRINT(I == 6 ? "" : " ");
        }
        IF (C < TO - 1) SPACE(GAP);
        ELSE PUTCHAR('\012');
    }

    WHILE (1) {
        FOR (C = FROM; C < TO; C++)
            IF (MONTHS[C].AT < MONTHS[C].DAYS) BREAK;
        IF (C == TO) BREAK;

        SPACE(LEAD);
        FOR (C = FROM; C < TO; C++) {
            FOR (I = 0; I < MONTHS[C].START_WDAY; I++) SPACE(3);
            WHILE(I++ < 7 && MONTHS[C].AT < MONTHS[C].DAYS) {
                INT MM = ++MONTHS[C].AT;
                PUTCHAR((MM < 10) ? ' ' : '0' + (MM /10));
                PUTCHAR('0' + (MM %10));
                IF (I < 7 || C < TO - 1) PUTCHAR(' ');
            }
            WHILE (I++ <= 7 && C < TO - 1) SPACE(3);
            IF (C < TO - 1) SPACE(GAP - 1);
            MONTHS[C].START_WDAY = 0;
        }
        PUTCHAR('\012');
    }
    PUTCHAR('\012');
}

VOID PRINT_YEAR(VOID)
{
    INT Y = YEAR;
    INT ROW;
    CHAR BUF[32];
    CHAR * B = &(BUF[31]);
    *B-- = '\0';
    DO {
        *B-- = '0' + (Y % 10);
        Y /= 10;
    } WHILE (Y > 0);
    B++;
    SPACE((WIDTH - STRLEN(B)) / 2);
    PRINT(B);PUTCHAR('\012');PUTCHAR('\012');
    FOR (ROW = 0; ROW * COLS < 12; ROW++)
        PRINT_ROW(ROW);
}

INT MAIN(INT C, CHAR **V)
{
    INT I, YEAR_SET = 0, RESULT = 0;
    FOR (I = 1; I < C && RESULT == 0; I++) {
        IF (V[I][0] == '-' && V[I][1] == 'W' && V[I][2] == '\0') {
            IF (++I == C || (WIDTH = ATOI(V[I])) < 20)
                RESULT = 1;
        } ELSE IF (!YEAR_SET) {
            YEAR = ATOI(V[I]);
            IF (YEAR <= 0)
                YEAR = 1969;
            YEAR_SET = 1;
        } ELSE
            RESULT = 1;
    }

    IF (RESULT == 0) {
        INIT_MONTHS();
        PRINT_YEAR();
    } ELSE {
        PRINT("BAD ARGS\012USAGE: ");
        PRINT(V[0]);
        PRINT(" YEAR [-W WIDTH (>= 20)]\012");
    }
RETURN RESULT;
}

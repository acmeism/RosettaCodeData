       IDENTIFICATION DIVISION.
       PROGRAM-ID. 8BALL.
       AUTHOR. Bill Gunshannon
       INSTALLATION.
       DATE-WRITTEN. 12 March 2024
      ************************************************************
      ** Program Abstract:
      **   Just ask the Magic 8 Ball and all will be revealed.
      ************************************************************

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       01  ANSWER-TABLE.
               10  ANSWER01   PIC X(40)
	   VALUE "As I see it, yes                        ".
               10  ANSWER02   PIC X(40)
	   VALUE "Ask again later                         ".
               10  ANSWER03   PIC X(40)
	   VALUE "Better not tell you now                 ".
               10  ANSWER04   PIC X(40)
	   VALUE "Cannot predict now                      ".
               10  ANSWER05   PIC X(40)
	   VALUE "Concentrate and ask again               ".
               10  ANSWER06   PIC X(40)
	   VALUE "Don't bet on it                         ".
               10  ANSWER07   PIC X(40)
	   VALUE "It is certain                           ".
               10  ANSWER08   PIC X(40)
	   VALUE "It is decidedly so                      ".
               10  ANSWER09   PIC X(40)
	   VALUE "Most likely                             ".
               10  ANSWER10   PIC X(40)
	   VALUE "My reply is no                          ".
               10  ANSWER11   PIC X(40)
	   VALUE "My sources say maybe                    ".
               10  ANSWER12   PIC X(40)
	   VALUE "My sources say no                       ".
               10  ANSWER13   PIC X(40)
	   VALUE "Outlook good                            ".
               10  ANSWER14   PIC X(40)
	   VALUE "Outlook not so good                     ".
               10  ANSWER15   PIC X(40)
	   VALUE "Reply hazy, try again                   ".
               10  ANSWER16   PIC X(40)
	   VALUE "Signs point to yes                      ".
               10  ANSWER17   PIC X(40)
	   VALUE "Very doubtful                           ".
               10  ANSWER18   PIC X(40)
	   VALUE "Without a doubt                         ".
               10  ANSWER19   PIC X(40)
	   VALUE "Yes                                     ".
               10  ANSWER20   PIC X(40)
	   VALUE "Yes, definitely                         ".
               10  ANSWER21   PIC X(40)
	   VALUE "Yes, probably not                       ".
               10  ANSWER22   PIC X(40)
	   VALUE "You may rely on it                      ".
               10  ANSWER23   PIC X(40)
	   VALUE "Your question has already been answered ".
       01  PRINT-ANSWER  REDEFINES ANSWER-TABLE OCCURS 23 TIMES.
               10 THE-BALL-SPEAKS     PIC X(40).

       01  RND         PIC 99999.
       01  QUESTION    PIC X(72).
       01  GREETING    PIC X(30)
           VALUE  "Ask and all will be revealed!!".


       PROCEDURE DIVISION.

       Main-Program.
           DISPLAY GREETING.
           ACCEPT QUESTION.
           MOVE FUNCTION CURRENT-DATE(1:16) TO RND.
            PERFORM 8-BALL.

           STOP RUN.

       8-BALL.
             COMPUTE RND =
                 FUNCTION RANDOM(RND) * 11111.
             DISPLAY PRINT-ANSWER(FUNCTION MOD(RND, 23)).


       END-PROGRAM.

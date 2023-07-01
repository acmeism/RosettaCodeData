        IDENTIFICATION DIVISION.
        PROGRAM-ID. OLD-LADY.

        DATA DIVISION.
        WORKING-STORAGE SECTION.

        01  LYRICS.
            03  THERE-WAS       PIC X(38) VALUE
            "There was an old lady who swallowed a ".
            03  SHE-SWALLOWED   PIC X(18) VALUE "She swallowed the ".
            03  TO-CATCH        PIC X(14) VALUE " to catch the ".
        01  ANIMALS.
            03  FLY.
                05  NAME        PIC X(6) VALUE "fly".
                05  VERSE       PIC X(60) VALUE
            "I don't know why she swallowed a fly. Perhaps she'll die.".
            03  SPIDER.
                05  NAME        PIC X(6) VALUE "spider".
                05  VERSE       PIC X(60) VALUE
            "That wiggled and jiggled and tickled inside her.".
            03  BIRD.
                05  NAME        PIC X(6) VALUE "bird".
                05  VERSE       PIC X(60) VALUE
            "How absurd, to swallow a bird.".
            03  CAT.
                05  NAME        PIC X(6) VALUE "cat".
                05  VERSE       PIC X(60) VALUE
            "Imagine that, she swallowed a cat.".
            03  DOG.
                05  NAME        PIC X(6) VALUE "dog".
                05  VERSE       PIC X(60) VALUE
            "What a hog, to swallow a dog.".
            03  GOAT.
                05  NAME        PIC X(6) VALUE "goat".
                05  VERSE       PIC X(60) VALUE
            "She just opened her throat and swallowed that goat.".
            03  COW.
                05  NAME        PIC X(6) VALUE "cow".
                05  VERSE       PIC X(60) VALUE
            "I don't know how she swallowed that cow.".
            03  HORSE.
                05  NAME        PIC X(6) VALUE "horse".
                05  VERSE       PIC X(60) VALUE
            "She's dead, of course.".
        01  ANIMAL-ARRAY REDEFINES ANIMALS.
            03  ANIMAL OCCURS 8 TIMES.
                05  NAME        PIC X(6).
                05  VERSE       PIC X(60).
        01  MISC.
            03  LINE-OUT        PIC X(80).
            03  A-IDX           PIC 9(2).
            03  S-IDX           PIC 9(2).

        PROCEDURE DIVISION.
        MAIN SECTION.
            PERFORM DO-ANIMAL
                VARYING A-IDX FROM 1 BY 1 UNTIL A-IDX > 8.
            STOP RUN.

        DO-ANIMAL SECTION.
            MOVE SPACES TO LINE-OUT.
            STRING
                THERE-WAS DELIMITED BY SIZE,
                NAME OF ANIMAL(A-IDX) DELIMITED BY SPACE,
                ","
                INTO LINE-OUT
            END-STRING.
            DISPLAY LINE-OUT.
            IF A-IDX > 1 THEN
                DISPLAY VERSE OF ANIMAL(A-IDX)
            END-IF.
            IF A-IDX = 8 THEN
                EXIT SECTION
            END-IF.
            PERFORM DO-SWALLOW
                VARYING S-IDX FROM A-IDX BY -1 UNTIL S-IDX = 1.
            DISPLAY VERSE OF ANIMAL(1).
            DISPLAY SPACES.

        DO-SWALLOW SECTION.
            MOVE SPACES TO LINE-OUT.
            STRING
                SHE-SWALLOWED DELIMITED BY SIZE,
                NAME OF ANIMAL(S-IDX) DELIMITED BY SPACE,
                TO-CATCH DELIMITED BY SIZE,
                NAME OF ANIMAL(S-IDX - 1) DELIMITED BY SPACE
                INTO LINE-OUT
            END-STRING.
            DISPLAY LINE-OUT.

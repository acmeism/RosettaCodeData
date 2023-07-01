PROGRAM EIGHT_BALL
    CHARACTER(LEN=100) :: RESPONSE
    CHARACTER(LEN=100) :: QUESTION
    CHARACTER(LEN=100), DIMENSION(20) :: RESPONSES
    REAL :: R

    CALL RANDOM_SEED()

    RESPONSES(1) = "It is certain"
    RESPONSES(2) = "It is decidedly so"
    RESPONSES(3) = "Without a doubt"
    RESPONSES(4) = "Yes, definitely"
    RESPONSES(5) = "You may rely on it"
    RESPONSES(6) = "As I see it, yes"
    RESPONSES(7) = "Most likely"
    RESPONSES(8) = "Outlook good"
    RESPONSES(9) = "Signs point to yes"
    RESPONSES(10) = "Yes"
    RESPONSES(11) = "Reply hazy, try again"
    RESPONSES(12) = "Ask again later"
    RESPONSES(13) = "Better not tell you now"
    RESPONSES(14) = "Cannot predict now"
    RESPONSES(15) = "Concentrate and ask again"
    RESPONSES(16) = "Don't bet on it"
    RESPONSES(17) = "My reply is no"
    RESPONSES(18) = "My sources say no"
    RESPONSES(19) = "Outlook not so good"
    RESPONSES(20) = "Very doubtful"

    WRITE(*,*) "Welcome to 8 Ball! Ask a question to find the answers"
    WRITE(*,*) "you seek, type either 'quit' or 'q' to exit", NEW_LINE('A')

    DO WHILE(.TRUE.)
        PRINT*, "Ask your question: "
        READ(*,*) QUESTION
        IF(QUESTION == "q" .OR. QUESTION == "quit") THEN
            CALL EXIT(0)
        ENDIF
        CALL RANDOM_NUMBER(R)
        PRINT*, "Response: ", TRIM(RESPONSES(FLOOR(R*20))), NEW_LINE('A')
    ENDDO
END PROGRAM EIGHT_BALL

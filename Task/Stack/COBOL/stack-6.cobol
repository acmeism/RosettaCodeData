       IDENTIFICATION DIVISION.
       PROGRAM-ID. stack-test.
       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       COPY stack.
       COPY stack REPLACING stack BY new-stack.
       PROCEDURE DIVISION.
         CALL "push" USING
           BY REFERENCE stack
           BY CONTENT "daleth"
         END-CALL
         CALL "push" USING
           BY REFERENCE stack
           BY CONTENT "gimel"
         END-CALL
         CALL "push" USING
           BY REFERENCE stack
           BY CONTENT "beth"
         END-CALL
         CALL "push" USING
           BY REFERENCE stack
           BY CONTENT "aleph"
         END-CALL
         CALL "traverse-stack" USING
           BY REFERENCE stack
         END-CALL
         CALL "reverse-stack" USING
           BY REFERENCE stack
           BY REFERENCE new-stack
         END-CALL
         CALL "traverse-stack" USING
           BY REFERENCE new-stack
         END-CALL
         STOP RUN.
       END PROGRAM stack-test.

       COPY stack-utilities.

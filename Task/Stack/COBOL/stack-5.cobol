       IDENTIFICATION DIVISION.
       PROGRAM-ID. push.
       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       COPY p.
       COPY node.
       LINKAGE SECTION.
       COPY stack.
       01  node-info-any PICTURE X ANY LENGTH.
       PROCEDURE DIVISION USING stack node-info-any.
         ALLOCATE node
         CALL "pointerp" USING
           BY REFERENCE ADDRESS OF node
           BY REFERENCE p
         END-CALL
         IF nil
           CALL "stack-overflow-error" END-CALL
         ELSE
           MOVE node-info-any TO info OF node
           SET link OF node TO head OF stack
           SET head OF stack TO ADDRESS OF node
         END-IF
         GOBACK.
       END PROGRAM push.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. pop.
       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       COPY p.
       COPY node.
       LINKAGE SECTION.
       COPY stack.
       COPY node-info.
       PROCEDURE DIVISION USING stack node-info.
         CALL "empty" USING
           BY REFERENCE stack
           BY REFERENCE p
         END-CALL
         IF t
           CALL "stack-underflow-error" END-CALL
         ELSE
           SET ADDRESS OF node TO head OF stack
           SET head OF stack TO link OF node
           MOVE info OF node TO node-info
         END-IF
         FREE ADDRESS OF node
         GOBACK.
       END PROGRAM pop.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. empty.
       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       LINKAGE SECTION.
       COPY stack.
       COPY p.
       PROCEDURE DIVISION USING stack p.
         CALL "pointerp" USING
           BY CONTENT head OF stack
           BY REFERENCE p
         END-CALL
         IF t
           SET t TO FALSE
         ELSE
           SET t TO TRUE
         END-IF
         GOBACK.
       END PROGRAM empty.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. head.
       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       COPY p.
       COPY node.
       LINKAGE SECTION.
       COPY stack.
       COPY node-info.
       PROCEDURE DIVISION USING stack node-info.
         CALL "empty" USING
           BY REFERENCE stack
           BY REFERENCE p
         END-CALL
         IF t
           CALL "stack-underflow-error" END-CALL
         ELSE
           SET ADDRESS OF node TO head OF stack
           MOVE info OF node TO node-info
         END-IF
         GOBACK.
       END PROGRAM head.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. peek.
       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       LINKAGE SECTION.
       COPY stack.
       COPY node-info.
       PROCEDURE DIVISION USING stack node-info.
         CALL "head" USING
           BY CONTENT stack
           BY REFERENCE node-info
         END-CALL
         GOBACK.
       END PROGRAM peek.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. pointerp.
       DATA DIVISION.
       LINKAGE SECTION.
       01  test-pointer USAGE IS POINTER.
       COPY p.
       PROCEDURE DIVISION USING test-pointer p.
         IF test-pointer EQUAL NULL
           SET nil TO TRUE
         ELSE
           SET t TO TRUE
         END-IF
         GOBACK.
       END PROGRAM pointerp.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. stack-overflow-error.
       PROCEDURE DIVISION.
         DISPLAY "stack-overflow-error" END-DISPLAY
         STOP RUN.
       END PROGRAM stack-overflow-error.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. stack-underflow-error.
       PROCEDURE DIVISION.
         DISPLAY "stack-underflow-error" END-DISPLAY
         STOP RUN.
       END PROGRAM stack-underflow-error.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. copy-stack.
       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       COPY p.
       COPY node-info.
       LINKAGE SECTION.
       COPY stack.
       COPY stack REPLACING stack BY new-stack.
       PROCEDURE DIVISION USING stack new-stack.
         CALL "empty" USING
           BY REFERENCE stack
           BY REFERENCE p
         END-CALL
         IF nil
           CALL "pop" USING
             BY REFERENCE stack
             BY REFERENCE node-info
           END-CALL
           CALL "copy-stack" USING
             BY REFERENCE stack
             BY REFERENCE new-stack
           END-CALL
           CALL "push" USING
             BY REFERENCE stack
             BY REFERENCE node-info
           END-CALL
           CALL "push" USING
             BY REFERENCE new-stack
             BY REFERENCE node-info
           END-CALL
         END-IF
         GOBACK.
       END PROGRAM copy-stack.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. reverse-stack.
       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       COPY p.
       COPY node-info.
       LINKAGE SECTION.
       COPY stack.
       COPY stack REPLACING stack BY new-stack.
       PROCEDURE DIVISION USING stack new-stack.
         CALL "empty" USING
           BY REFERENCE stack
           BY REFERENCE p
         END-CALL
         IF nil
           CALL "pop" USING
             BY REFERENCE stack
             BY REFERENCE node-info
           END-CALL
           CALL "push" USING
             BY REFERENCE new-stack
             BY REFERENCE node-info
           END-CALL
           CALL "reverse-stack" USING
             BY REFERENCE stack
             BY REFERENCE new-stack
           END-CALL
           CALL "push" USING
             BY REFERENCE stack
             BY REFERENCE node-info
           END-CALL
         END-IF
         GOBACK.
       END PROGRAM reverse-stack.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. traverse-stack.
       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       COPY p.
       COPY node-info.
       COPY stack REPLACING stack BY new-stack.
       LINKAGE SECTION.
       COPY stack.
       PROCEDURE DIVISION USING stack.
         CALL "copy-stack" USING
           BY REFERENCE stack
           BY REFERENCE new-stack
         END-CALL
         CALL "empty" USING
           BY REFERENCE new-stack
           BY REFERENCE p
         END-CALL
         IF nil
           CALL "head" USING
             BY CONTENT new-stack
             BY REFERENCE node-info
           END-CALL
           DISPLAY node-info END-DISPLAY
           CALL "peek" USING
             BY CONTENT new-stack
             BY REFERENCE node-info
           END-CALL
           DISPLAY node-info END-DISPLAY
           CALL "pop" USING
             BY REFERENCE new-stack
             BY REFERENCE node-info
           END-CALL
           DISPLAY node-info END-DISPLAY
           CALL "traverse-stack" USING
             BY REFERENCE new-stack
           END-CALL
         END-IF
         GOBACK.
       END PROGRAM traverse-stack.

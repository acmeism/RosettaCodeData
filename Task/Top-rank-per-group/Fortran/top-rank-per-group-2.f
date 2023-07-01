      PROGRAM TOP RANK   !Just do it.
      CHARACTER*28 HEADING(4)   !The first line is a header.
      TYPE GRIST        !But this is the stuff.
       CHARACTER*28 NAME        !Arbitrary sizes.
       CHARACTER*6 ID           !Possibly imperfect.
       REAL*8 SALARY            !Single precision is a bit thin.
       CHARACTER*6 DEPARTMENT       !Not a number.
      END TYPE GRIST        !So much for the aggregate.
      INTEGER HORDE     !Some parameterisation.
      PARAMETER (HORDE = 66)    !This should suffice.
      TYPE(GRIST) EMPLOYEE(HORDE),HIC   !An extra for the sort.
      LOGICAL CURSE     !Possible early completion.
      INTEGER I,N,H     !Steppers.
      INTEGER II,R      !Needed for the results.
      INTEGER KBD,MSG,IN    !I/O unit numbers.

      KBD = 5   !Standard input.
      MSG = 6   !Standard output.
      IN = 10   !Suitable for an input file.
      WRITE (MSG,1)
    1 FORMAT ("Reads a set of employee information from TopRank.csv"/
     1"Then for each department code, shows the N highest paid.")
      OPEN (IN,NAME = "TopRank.csv",FORM = "FORMATTED")
      READ (IN,*) HEADING   !Column headings: the "Salary" heading is not numeric.
Chug through the input.
      N = 0     !None so far.
   10 READ (IN,*,END = 20) EMPLOYEE(N + 1)  !Get the next record.
      N = N + 1                 !We did. Count it in.
      IF (N.GT.HORDE) STOP "Too many employee records!" !Ah, suspicion.
      GO TO 10                  !Perhaps there will be another.
Collate the collection.
   20 CLOSE(IN)         !Finished with the input.
Crank up a comb sort, which requires only one comparison statement. Especially good for compound fields.
      H = N - 1         !Last - first, and not + 1.
   21 H = MAX(1,H*10/13)    !The special feature.
      CURSE = .FALSE.       !So far, so good.
      DO I = N - H,1,-1     !If H = 1, this is a Bubblesort.
        IF (EMPLOYEE(I).DEPARTMENT.LT.EMPLOYEE(I + H).DEPARTMENT) CYCLE !In order by department.
        IF (EMPLOYEE(I).DEPARTMENT.EQ.EMPLOYEE(I + H).DEPARTMENT    !Or, Equal department,
     *  .AND. EMPLOYEE(I).SALARY.GT.EMPLOYEE(I + H).SALARY) CYCLE   !And in decreasing order by salary.
        CURSE = .TRUE.          !No escape. the elements are in the wrong order.
        HIC = EMPLOYEE(I)       !So a SWAP statement would be good. But alas.
        EMPLOYEE(I) = EMPLOYEE(I + H)   !For large data aggregates, an indexed sort would be good.
        EMPLOYEE(I + H) = HIC       !But, just slog away.
      END DO                !Consider the next pairing.
      IF (CURSE .OR. H.GT.1) GO TO 21   !Work remains?

Cast forth results.
   30 WRITE (6,31) N    !Announce, and solicit a parameter.
   31 FORMAT (I0," employees. How many per dept? ",$)   !The $ sez "don't start a new line."
      READ (KBD,*) R    !The parameter.
      IF (R.LE.0) STOP  !bah.
      WRITE (MSG,32) "Rank",HEADING
   32 FORMAT (/,A6,1X,A28,2X,A12,1X,A10,A)  !Compare to FORMAT 33.
      HIC.DEPARTMENT = "...Not this"    !Different from all departmental codes.
      DO I = 1,N    !Scan the sorted data.
        IF (HIC.DEPARTMENT.EQ.EMPLOYEE(I).DEPARTMENT) THEN  !Another?
          II = II + 1       !Same department, so count another adherent.
         ELSE           !But with a change of department code,
          II = 1        !Start a fresh count.
          HIC.DEPARTMENT = EMPLOYEE(I).DEPARTMENT   !And remember the new code.
          WRITE (MSG,*) "For ",HIC.DEPARTMENT   !Announce the new department's code.
        END IF          !So much for grouping.
        IF (II.LE.R) WRITE (MSG,33) II,EMPLOYEE(I)  !Still within the desired rank?
   33   FORMAT (I6,1X,A28,1X,A12,F11.2,1X,A)    !Some layout. Includes the repeated departmental code name.
      END DO            !On to the next.

      END   !That was straightforward.

FCD
 NEW D,SEP,EQ,LONG,DONE,I,J,K,RETURN
 SET D(1)="/home/user1/tmp/coverage/test"
 SET D(2)="/home/user1/tmp/covert/operator"
 SET D(3)="/home/user1/tmp/coven/members"
 SET SEP="/"
 SET LONG=D(1)
 SET DONE=0
 FOR I=1:1:$LENGTH(LONG,SEP) QUIT:DONE  SET EQ(I)=1 FOR J=2:1:3 SET EQ(I)=($PIECE(D(J),SEP,I)=$PIECE(LONG,SEP,I))&EQ(I) SET DONE='EQ(I) QUIT:'EQ(I)
 SET RETURN=""
 FOR K=1:1:I-1 Q:'EQ(K)  SET:EQ(K) $PIECE(RETURN,SEP,K)=$PIECE(LONG,SEP,K)
 WRITE !,"For the paths:" FOR I=1:1:3 WRITE !,D(I)
 WRITE !,"The longest common directory is: ",RETURN
 KILL D,SEP,EQ,LONG,DONE,I,J,K,RETURN
 QUIT

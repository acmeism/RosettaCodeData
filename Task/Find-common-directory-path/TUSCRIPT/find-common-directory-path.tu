$$ MODE TUSCRIPT
common=""
dir1="/home/user1/tmp/coverage/test"
dir2="/home/user1/tmp/covert/operator"
dir3="/home/user1/tmp/coven/members"
dir1=SPLIT (dir1,":/:"),dir2=SPLIT (dir2,":/:"), dir3=SPLIT (dir3,":/:")
LOOP d1=dir1,d2=dir2,d3=dir3
 IF (d1==d2,d3) THEN
  common=APPEND(common,d1,"/")
 ELSE
  PRINT common
  EXIT
 ENDIF
ENDLOOP

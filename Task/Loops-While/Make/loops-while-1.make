NEXT=`expr $* / 2`
MAX=10

all: $(MAX)-n;

0-n:;

%-n: %-echo
       @-make -f while.mk $(NEXT)-n MAX=$(MAX)

%-echo:
       @echo $*

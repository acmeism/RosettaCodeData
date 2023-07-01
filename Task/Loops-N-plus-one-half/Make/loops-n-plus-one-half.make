NEXT=`expr $* + 1`
MAX=10
RES=1

all: 1-n;

$(MAX)-n:
       @echo $(RES)

%-n:
       @-make -f loop.mk $(NEXT)-n MAX=$(MAX) RES=$(RES),$(NEXT)

A=
B=

ifeq "$(A)" "1"
       B=true
else
       B=false
endif

do:
       @echo $(A) ..  $(B)

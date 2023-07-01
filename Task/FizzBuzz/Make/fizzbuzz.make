MOD3 = 0
MOD5 = 0
ALL != jot 100

all: say-100

.for NUMBER in $(ALL)

MOD3 != expr \( $(MOD3) + 1 \) % 3; true
MOD5 != expr \( $(MOD5) + 1 \) % 5; true

. if "$(NUMBER)" > 1
PRED != expr $(NUMBER) - 1
say-$(NUMBER): say-$(PRED)
. else
say-$(NUMBER):
. endif
. if "$(MOD3)$(MOD5)" == "00"
	@echo FizzBuzz
. elif "$(MOD3)" == "0"
	@echo Fizz
. elif "$(MOD5)" == "0"
	@echo Buzz
. else
	@echo $(NUMBER)
. endif

.endfor

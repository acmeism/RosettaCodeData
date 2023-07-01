all: line-5

ILIST != jot 5
.for I in $(ILIST)

line-$(I): asterisk-$(I)-$(I)
	@echo

JLIST != jot $(I)
. for J in $(JLIST)

.  if "$(J)" == "1"
.   if "$(I)" == "1"
asterisk-1-1:
.   else
IM != expr $(I) - 1
asterisk-$(I)-1: line-$(IM)
.   endif
.  else
JM != expr $(J) - 1
asterisk-$(I)-$(J): asterisk-$(I)-$(JM)
.  endif
	@printf \*

. endfor
.endfor

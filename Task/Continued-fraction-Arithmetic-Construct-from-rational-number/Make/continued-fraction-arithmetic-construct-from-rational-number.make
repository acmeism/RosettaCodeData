.SILENT:
.DEFAULT_GOAL := start-here

define r2cf =
	M=`expr $(1)`; \
	N=`expr $(2)`; \
	printf '%d/%d => ' $$M $$N; \
	SEP='['; \
	while test $$N -ne 0; do \
		printf "%s%d" "$$SEP" `expr $$M '/' $$N`; \
		if test "$$SEP" = '['; then SEP='; '; else SEP=', '; fi; \
		R=`expr $$M '%' $$N`; \
		M=$$N; \
		N=$$R; \
	done; \
	printf ']\n'
endef

start-here:
	$(call r2cf, 1, 2)
	$(call r2cf, 3, 1)
	$(call r2cf, 23, 8)
	$(call r2cf, 13, 11)
	$(call r2cf, 22, 7)
	$(call r2cf, -151, 77)

	$(call r2cf, 14142, 10000)
	$(call r2cf, 141421, 100000)
	$(call r2cf, 1414214, 1000000)
	$(call r2cf, 14142136, 10000000)

	$(call r2cf, 31, 10)
	$(call r2cf, 314, 100)
	$(call r2cf, 3142, 1000)
	$(call r2cf, 31428, 10000)
	$(call r2cf, 314285, 100000)
	$(call r2cf, 3142857, 1000000)
	$(call r2cf, 31428571, 10000000)
	$(call r2cf, 314285714, 100000000)

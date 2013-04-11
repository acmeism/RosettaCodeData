A=1
B=1

define multiply
   expr $(1) \* $(2)
endef

do:
   @$(call multiply, $(A), $(B))

|gmake -f mul.mk do A=5 B=3

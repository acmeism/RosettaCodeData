# gnu make

COMMON := -Wall -g -fPIC -fopenmp
override FFLAGS += ${COMMON} -ffree-form -fall-intrinsics -fimplicit-none

%: %.F08
	gfortran -std=f2008 $(FFLAGS) $< -o $@

%.o: %.F08
	gfortran -std=f2008 -c $(FFLAGS) $< -o $@

%: %.f08
	gfortran -std=f2008 $(FFLAGS) $< -o $@

%.o: %.f08
	gfortran -std=f2008 -c $(FFLAGS) $< -o $@

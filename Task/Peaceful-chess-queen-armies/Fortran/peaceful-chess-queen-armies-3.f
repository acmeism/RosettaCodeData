#!/bin/sh
#
# Driver script for peaceful_queens in Fortran.
#

if test ${ZSH_VERSION+y} && (emulate sh) >/dev/null 2>&1; then
    emulate sh
fi

if test $# -ne 3 && test $# -ne 4; then
    echo "Usage: $0 M N MAX_SOLUTIONS [SHOW_EQUIVALENTS]"
    exit 1
fi

M=${1}
N=${2}
MAX_SOLUTIONS=${3}
SHOW_EQUIVALENTS=${4}

RM_GENERATED_SRC=yes
CHECK=no

case ${CHECK} in
    0 | f | F | false | N | n | no) FCCHECK="" ;;
    1 | t | T | true | Y | y | yes) FCCHECK="-fcheck=all" ;;
    *) echo 'CHECK is set incorrectly';
       exit 1 ;;
esac

FC="gfortran"
FCFLAGS="-std=f2018 -g -O3 -march=native -fno-stack-protector -Wall -Wextra ${FCCHECK}"

# If you have the graphite optimizer, here are some marginally helpful
# flags. They barely make a difference, for me.
FCFLAGS="${FCFLAGS} -funroll-loops -floop-nest-optimize"

RUN_IT="yes"

${FC} -o peaceful_queens_elements_generator peaceful_queens_elements_generator.f90 &&
    ./peaceful_queens_elements_generator ${M} ${N} ${MAX_SOLUTIONS} > peaceful_queens_elements.f90 &&
    ${FC} ${FCFLAGS} -c peaceful_queens_elements.f90 &&
    if test x"${RM_GENERATED_SRC}" != xno; then rm -f peaceful_queens_elements.f90; fi &&
    ${FC} ${FCFLAGS} -c peaceful_queens.f90 &&
    ${FC} ${FCFLAGS} -o peaceful_queens peaceful_queens_elements.o peaceful_queens.o &&
    if test x"${RUN_IT}" = xyes; then time ./peaceful_queens ${SHOW_EQUIVALENTS}; else :; fi

v = pointer[3]; /* accesses third-next object, i.e. array[4] */
v = pointer[-1]; /* accesses previous object, i.e. array[0] */
/* or alternatively */
v = *(pointer + 3); /* array[4] */
v = *(pointer - 1); /* array[0] */

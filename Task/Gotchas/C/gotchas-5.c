int foo[4] = { 4, 8, 12, 16 };
int x = foo[0];  /* x = 4 */
int y = foo[3];  /* y = 16 */
int z = foo[4];  /* z contains whatever was after foo[3] in memory */

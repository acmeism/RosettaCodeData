int x = 3;
int y = 5;
printf("%d %d %x\n",x,y);	/* this may crash or print undefined values after 3 5 */
printf("testing %n\n");	/* this writes the int value 8 to an undefined location */

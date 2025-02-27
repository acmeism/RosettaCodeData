int gotcha(char bar[])	/* could have been: int gotcha(char *bar) */
{
	return sizeof(bar);	/* returns the size of a pointer to char, probably 4 on 32-bit systems and 8 on 64-bit systems */
}

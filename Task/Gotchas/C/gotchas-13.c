void
say_hello(const char *name)	/* assume name is something the user entered */
{
	printf("hello ");
	printf(name);	/* the name entered could be "%s" or "%n" or something */
	printf("\n");
}

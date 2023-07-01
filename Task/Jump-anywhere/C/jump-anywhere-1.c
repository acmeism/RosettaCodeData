	if (x > 0) goto positive;
	else goto negative;

positive:
	printf("pos\n"); goto both;

negative:
	printf("neg\n");

both:
	...

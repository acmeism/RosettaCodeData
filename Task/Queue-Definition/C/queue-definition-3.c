int main()
{
	int i, n;
	queue q = q_new();

	for (i = 0; i < 100000000; i++) {
		n = rand();
		if (n > RAND_MAX / 2) {
		//	printf("+ %d\n", n);
			enqueue(q, n);
		} else {
			if (!dequeue(q, &n)) {
			//	printf("empty\n");
				continue;
			}
		//	printf("- %d\n", n);
		}
	}
	while (dequeue(q, &n));// printf("- %d\n", n);

	return 0;
}

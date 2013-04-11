#include <stdio.h>
#include <stdlib.h>

int rand_i(int n)
{
	int rand_max = RAND_MAX - (RAND_MAX % n);
	int ret;
	while ((ret = rand()) >= rand_max);
	return ret/(rand_max / n);
}

int weighed_rand(int *tbl, int len)
{
	int i, sum, r;
	for (i = 0, sum = 0; i < len; sum += tbl[i++]);
	if (!sum) return rand_i(len);

	r = rand_i(sum) + 1;
	for (i = 0; i < len && (r -= tbl[i]) > 0; i++);
	return i;
}

int main()
{
	int user_action, my_action;
	int user_rec[] = {0, 0, 0};
	const char *names[] = { "Rock", "Paper", "Scissors" };
	char str[2];
	const char *winner[] = { "We tied.", "Meself winned.", "You win." };

	while (1) {
		my_action = (weighed_rand(user_rec, 3) + 1) % 3;

		printf("\nYour choice [1-3]:\n"
			"  1. Rock\n  2. Paper\n  3. Scissors\n> ");

		/* scanf is a terrible way to do input.  should use stty and keystrokes */
		if (!scanf("%d", &user_action)) {
			scanf("%1s", str);
			if (*str == 'q') return 0;
			continue;
		}
		user_action --;
		if (user_action > 2 || user_action < 0) {
			printf("invalid choice; again\n");
			continue;
		}
		printf("You chose %s; I chose %s. %s\n",
			names[user_action], names[my_action],
			winner[(my_action - user_action + 3) % 3]);

		user_rec[user_action]++;
	}
}

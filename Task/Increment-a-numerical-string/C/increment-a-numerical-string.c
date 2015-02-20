#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/*  Constraints: input is in the form of (\+|-)?[0-9]+
 *  and without leading zero (0 itself can be as "0" or "+0", but not "-0");
 *  input pointer is realloc'able and may change;
 *  if input has leading + sign, return may or may not keep it.
 *  The constranits conform to sprintf("%+d") and this function's own output.
 */
char * incr(char *s)
{
	int i, begin, tail, len;
	int neg = (*s == '-');
	char tgt = neg ? '0' : '9';

	/* special case: "-1" */
	if (!strcmp(s, "-1")) {
		s[0] = '0', s[1] = '\0';
		return s;
	}

	len = strlen(s);
	begin = (*s == '-' || *s == '+') ? 1 : 0;

	/* find out how many digits need to be changed */
	for (tail = len - 1; tail >= begin && s[tail] == tgt; tail--);

	if (tail < begin && !neg) {
		/* special case: all 9s, string will grow */
		if (!begin) s = realloc(s, len + 2);
		s[0] = '1';
		for (i = 1; i <= len - begin; i++) s[i] = '0';
		s[len + 1] = '\0';
	} else if (tail == begin && neg && s[1] == '1') {
		/* special case: -1000..., so string will shrink */
		for (i = 1; i < len - begin; i++) s[i] = '9';
		s[len - 1] = '\0';
	} else { /* normal case; change tail to all 0 or 9, change prev digit by 1*/
		for (i = len - 1; i > tail; i--)
			s[i] = neg ? '9' : '0';
		s[tail] += neg ? -1 : 1;
	}

	return s;
}

void string_test(const char *s)
{
	char *ret = malloc(strlen(s));
	strcpy(ret, s);

	printf("text: %s\n", ret);
	printf("  ->: %s\n", ret = incr(ret));
	free(ret);
}

int main()
{
	string_test("+0");
	string_test("-1");
	string_test("-41");
	string_test("+41");
	string_test("999");
	string_test("+999");
	string_test("109999999999999999999999999999999999999999");
	string_test("-100000000000000000000000000000000000000000000");

	return 0;
}

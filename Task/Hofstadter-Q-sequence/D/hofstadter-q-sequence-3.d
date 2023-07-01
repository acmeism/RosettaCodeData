import std.stdio;

int[100_000] Q;

void main() {
	Q[0] = 1;
	Q[1] = 1;

	for (int i = 2; i < 100_000; i++)
	{
		Q[i] = Q[i - Q[i - 1]] + Q[i - Q[i - 2]];
	}

	write("Q(1..10) : ");
	for (int i = 0; i < 10; i++)
	{
		write(" ", Q[i]);
	}
	writeln;

	write("Q(1000) : ");
	writeln(Q[999]);

	int lt = 0;
	for (int i = 1; i < 100_000; i++)
	{
		if( Q[i-1] > Q[i] ) lt++;
	}

	writefln("Q(i) is less than Q(i-1) for i [2..100_000] %d times.", lt);
}

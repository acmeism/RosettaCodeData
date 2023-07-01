#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXPRIME 99						// upper bound for the prime factors
#define MAXPARENT 99					// greatest parent number
#define NBRPRIMES 30					// max number of prime factors
#define NBRANCESTORS 10					// max number of parent's ancestors

FILE *FileOut;
char format[] = ", %lld";

int Primes[NBRPRIMES];					// table of the prime factors
int iPrimes;							// max index of the prime factor table

short Ancestors[NBRANCESTORS];			// table of the parent's ancestors

struct Children {
	long long Child;
	struct Children *pLower;
	struct Children *pHigher;
};
struct Children *Parents[MAXPARENT+1];	// table pointing to the root descendants (per parent)
int CptDescendants[MAXPARENT+1];		// counter table of the descendants (per parent)

void InsertPreorder(struct Children *node, short sum, int prime);
struct Children *InsertChild(struct Children *node, long long child);
void RemoveFalseChildren();
short GetAncestors(short child);
void PrintDescendants(struct Children *node);
int GetPrimes(int primes[], int maxPrime);

int main()
{
	short i, Parent, Sum, Level;
	int Prime;
	int TotDesc = 0;
	int MidPrime;
	
	if ((iPrimes = GetPrimes(Primes, MAXPRIME)) < 0)
		return 1;

	MidPrime = Primes[iPrimes] / 2;

	for (i = iPrimes; i >= 0; i--)
	{
		Prime = Primes[i];
		Parents[Prime] = InsertChild(Parents[Prime], Prime);
		CptDescendants[Prime]++;

		if (Prime > MidPrime)
			continue;

		for (Parent = 1; Parent <= MAXPARENT; Parent++)
		{
			if ((Sum = Parent+Prime) > MAXPARENT)
				break;

			if (Parents[Parent])
			{
				InsertPreorder(Parents[Parent], Sum, Prime);
				CptDescendants[Sum] += CptDescendants[Parent];
			}
		}
	}

	RemoveFalseChildren();

	if (MAXPARENT > MAXPRIME)
		if (GetPrimes(Primes, MAXPARENT) < 0)
			return 1;

	if (fopen_s(&FileOut, "Ancestors.txt", "w"))
		return 1;

	for (Parent = 1; Parent <= MAXPARENT; Parent++)
	{
		Level = GetAncestors(Parent);
		
		fprintf(FileOut, "[%d] Level: %d\n", Parent, Level);
		
		if (Level)
		{
			fprintf(FileOut, "Ancestors: %d", Ancestors[0]);
			
			for (i = 1; i < Level; i++)
				fprintf(FileOut, ", %d", Ancestors[i]);
		}
		else
			fprintf(FileOut, "Ancestors: None");

		if (CptDescendants[Parent])
		{
			fprintf(FileOut, "\nDescendants: %d\n", CptDescendants[Parent]);
			strcpy_s(format, "%lld");
			PrintDescendants(Parents[Parent]);
			fprintf(FileOut, "\n");
		}
		else
			fprintf(FileOut, "\nDescendants: None\n");

		fprintf(FileOut, "\n");
		TotDesc += CptDescendants[Parent];
	}

	fprintf(FileOut, "Total descendants %d\n\n", TotDesc);
	
	if (fclose(FileOut))
		return 1;

	return 0;
}

void InsertPreorder(struct Children *node, short sum, int prime)
{
	Parents[sum] = InsertChild(Parents[sum], node->Child * prime);

	if (node->pLower)
		InsertPreorder(node->pLower, sum, prime);

	if (node->pHigher)
		InsertPreorder(node->pHigher, sum, prime);
}

struct Children *InsertChild(struct Children *node, long long child)
{
	if (node)
	{
		if (child <= node->Child)
			node->pLower = InsertChild(node->pLower, child);
		else
			node->pHigher = InsertChild(node->pHigher, child);
	}
	else
	{
		if (node = (struct Children *) malloc(sizeof(struct Children)))
		{
			node->Child = child;
			node->pLower = NULL;
			node->pHigher = NULL;
		}
	}

	return node;
}

void RemoveFalseChildren()
{
	short i, ex;
	int Exclusions[NBRPRIMES+1];		// table of the prime factors + {4}
	int iExclusions;					// max index of the exclusion table
	struct Children *ptr;

	for (i = 0; i <= iPrimes; i++)
		Exclusions[i] = Primes[i];

	iExclusions = iPrimes + 1;
	Exclusions[iExclusions] = 4;

	for (i = 0; i <= iExclusions; i++)
	{
		ex = Exclusions[i];
		ptr = Parents[ex];
		Parents[ex] = ptr->pHigher;
		CptDescendants[ex]--;
		free(ptr);
	}
}

short GetAncestors(short child)
{
	short Child = child;
	short Parent = 0;
	short Index = 0;
	
	while (Child > 1)
	{
		while (Child % Primes[Index] == 0)
		{
			Child /= Primes[Index];
			Parent += Primes[Index];
		}
		
		Index++;
	}
	
	if (Parent == child || child == 1)
		return 0;
	
	Index = GetAncestors(Parent);
	
	Ancestors[Index] = Parent;
	return ++Index;
}

void PrintDescendants(struct Children *node)
{
	if (node->pLower)
		PrintDescendants(node->pLower);
	
	fprintf(FileOut, format, node->Child);
	strcpy_s(format, ", %lld");
	
	if (node->pHigher)
		PrintDescendants(node->pHigher);

	free(node);
	return;
}

int GetPrimes(int primes[], int maxPrime)
{
	if (maxPrime < 2)
		return -1;
	
	int Index = 0, Value = 1;
	int Max, i;

	primes[0] = 2;

	while ((Value += 2) <= maxPrime)
	{
		Max = (int) floor(sqrt((double) Value));
		
		for (i = 0; i <= Index; i++)
		{
			if (primes[i] > Max)
			{
				if (++Index >= NBRPRIMES)
					return -1;

				primes[Index] = Value;
				break;
			}

			if (Value % primes[i] == 0)
				break;
		}
	}

	return Index;
}

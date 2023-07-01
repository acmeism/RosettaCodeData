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
	struct Children *pNext;
};
struct Children *Parents[MAXPARENT+1][2];	// table pointing to the root and to the last descendants (per parent)
int CptDescendants[MAXPARENT+1];			// counter table of the descendants (per parent)
long long MaxDescendant = (long long) pow(3.0, 33.0);	// greatest descendant number

short GetParent(long long child);
struct Children *AppendChild(struct Children *node, long long child);
short GetAncestors(short child);
void PrintDescendants(struct Children *node);
int GetPrimes(int primes[], int maxPrime);

int main()
{
	long long Child;
	short i, Parent, Level;
	int TotDesc = 0;
	
	if ((iPrimes = GetPrimes(Primes, MAXPRIME)) < 0)
		return 1;
	
	for (Child = 1; Child <= MaxDescendant; Child++)
	{
		if (Parent = GetParent(Child))
		{
			Parents[Parent][1] = AppendChild(Parents[Parent][1], Child);
			if (Parents[Parent][0] == NULL)
				Parents[Parent][0] = Parents[Parent][1];
			CptDescendants[Parent]++;
		}
	}
	
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
			PrintDescendants(Parents[Parent][0]);
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

short GetParent(long long child)
{
	long long Child = child;
	short Parent = 0;
	short Index = 0;
	
	while (Child > 1 && Parent <= MAXPARENT)
	{
		if (Index > iPrimes)
			return 0;

		while (Child % Primes[Index] == 0)
		{
			Child /= Primes[Index];
			Parent += Primes[Index];
		}

		Index++;
	}
	
	if (Parent == child || Parent > MAXPARENT || child == 1)
		return 0;
	
	return Parent;
}

struct Children *AppendChild(struct Children *node, long long child)
{
	static struct Children *NodeNew;
	
	if (NodeNew = (struct Children *) malloc(sizeof(struct Children)))
	{
		NodeNew->Child = child;
		NodeNew->pNext = NULL;
		if (node != NULL)
			node->pNext = NodeNew;
	}
	
	return NodeNew;
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
	static struct Children *NodeCurr;
	static struct Children *NodePrev;

	NodeCurr = node;
	NodePrev = NULL;
	while (NodeCurr)
	{
		fprintf(FileOut, format, NodeCurr->Child);
		strcpy_s(format, ", %lld");
		NodePrev = NodeCurr;
		NodeCurr = NodeCurr->pNext;
		free(NodePrev);
	}

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

/*Abhishek Ghosh, 24th September 2017*/

#include<stdio.h>

int main()
{
	FILE* fp = fopen("TAPE.FILE","w");
	
	fprintf(fp,"This code should be able to write a file to magnetic tape.\n");
	fprintf(fp,"The Wikipedia page on Magnetic tape data storage shows that magnetic tapes are still in use.\n");
	fprintf(fp,"In fact, the latest format, at the time of writing this code is TS1155 released in 2017.\n");
	fprintf(fp,"And since C is already 44, maybe 45, years old in 2017, I am sure someone somewhere did use a C compiler on magnetic tapes.\n");
	fprintf(fp,"If you happen to have one, please try to compile and execute me on that system.\n");
	fprintf(fp,"My creator tested me on an i5 machine with SSD and RAM that couldn't have even been dreamt of by Denis Ritchie.\n");
	fprintf(fp,"Who knows ? Maybe he did foresee today, after all he created something which is still young after 44-45 years and counting...\n");
	fprintf(fp,"EOF");
	
	fclose(fp);
	
	return 0;
}

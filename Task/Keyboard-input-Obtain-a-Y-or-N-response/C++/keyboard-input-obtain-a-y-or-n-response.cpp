#include <conio.h>
#include <iostream>

using namespace std;

int main()
{
	char ch;
	_cputs( "Yes or no?" );
	do
	{
		ch = _getch();
		ch = toupper( ch );
	} while(ch!='Y'&&ch!='N');

	if(ch=='N')
	{
		cout << "You said no" << endl;
	}
	else
	{
		cout << "You said yes" << endl;
	}
	return 0;
}

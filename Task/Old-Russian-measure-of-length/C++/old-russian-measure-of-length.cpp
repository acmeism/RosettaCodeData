#include <iostream>
#include <iomanip>
//-------------------------------------------------------------------------------------------
using namespace std;

//-------------------------------------------------------------------------------------------
class ormConverter
{
public:
    ormConverter() :  AR( 0.7112f ), CE( 0.01f ), DI( 0.0254f ), FU( 0.3048f ), KI( 1000.0f ), LI( 0.00254f ), ME( 1.0f ),
		      MI( 7467.6f ), PI( 0.1778f ), SA( 2.1336f ), TO( 0.000254f ), VE( 0.04445f ), VR( 1066.8f ) {}
    void convert( char c, float l )
    {
	system( "cls" );
	cout << endl << l;
	switch( c )
	{
	    case 'A': cout << " Arshin to:";     l *= AR; break;
	    case 'C': cout << " Centimeter to:"; l *= CE; break;
	    case 'D': cout << " Diuym to:";      l *= DI; break;
	    case 'F': cout << " Fut to:";        l *= FU; break;
	    case 'K': cout << " Kilometer to:";  l *= KI; break;
	    case 'L': cout << " Liniya to:";     l *= LI; break;
	    case 'M': cout << " Meter to:";      l *= ME; break;
	    case 'I': cout << " Milia to:";      l *= MI; break;
	    case 'P': cout << " Piad to:";       l *= PI; break;
	    case 'S': cout << " Sazhen to:";     l *= SA; break;
	    case 'T': cout << " Tochka to:";     l *= TO; break;
	    case 'V': cout << " Vershok to:";    l *= VE; break;
	    case 'E': cout << " Versta to:";     l *= VR;
	}

	float ar = l / AR, ce = l / CE, di = l / DI, fu = l / FU, ki = l / KI, li = l / LI, me = l / ME,
	      mi = l / MI, pi = l / PI, sa = l / SA, to = l / TO, ve = l / VE, vr = l / VR;
	cout << left << endl << "=================" << endl
	     << setw( 12 ) << "Arshin:" << ar << endl << setw( 12 ) << "Centimeter:" << ce << endl
	     << setw( 12 ) << "Diuym:" << di << endl << setw( 12 ) << "Fut:" << fu << endl
	     << setw( 12 ) << "Kilometer:" << ki << endl << setw( 12 ) << "Liniya:" << li << endl
	     << setw( 12 ) << "Meter:" << me << endl << setw( 12 ) << "Milia:" << mi << endl
	     << setw( 12 ) << "Piad:" << pi << endl << setw( 12 ) << "Sazhen:" << sa << endl
	     << setw( 12 ) << "Tochka:" << to << endl << setw( 12 ) << "Vershok:" << ve << endl
	     << setw( 12 ) << "Versta:" << vr << endl << endl << endl;
    }
private:
    const float AR, CE, DI, FU, KI, LI, ME, MI, PI, SA, TO, VE, VR;
};
//-------------------------------------------------------------------------------------------
int _tmain(int argc, _TCHAR* argv[])
{
    ormConverter c;
    char s; float l;
    while( true )
    {
	cout << "What unit:\n(A)rshin, (C)entimeter, (D)iuym, (F)ut\n(K)ilometer, (L)iniya, (M)eter, m(I)lia, (P)iad\n(S)azhen, (T)ochka, (V)ershok, v(E)rsta, (Q)uit\n";
	cin >> s; if( s & 32 ) s ^= 32; if( s == 'Q' ) return 0;
	cout << "Length (0 to Quit): "; cin >> l; if( l == 0 ) return 0;
	c.convert( s, l ); system( "pause" ); system( "cls" );
    }
    return 0;
}
//-------------------------------------------------------------------------------------------

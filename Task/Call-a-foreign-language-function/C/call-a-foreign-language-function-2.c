#include <python2.7/Python.h>

int main()
{
	Py_Initialize();
  	PyRun_SimpleString("a = [3*x for x in range(1,11)]");
  	
	PyRun_SimpleString("print 'First 10 multiples of 3  : ' + str(a)");

	PyRun_SimpleString("print 'Last 5 multiples of 3 : ' + str(a[5:])");

	PyRun_SimpleString("print 'First 10 multiples of 3 in reverse order : ' + str(a[::-1])");

	Py_Finalize();
	return 0;
}

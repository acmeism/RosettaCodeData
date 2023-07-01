#include <stdexcept>

template <typename Self>
class singleton
{
protected:
	static Self*
		sentry;
public:	
	static Self&
		instance()
	{
		return *sentry;
	}
	singleton()
	{
		if(sentry)
			throw std::logic_error("Error: attempt to instantiate a singleton over a pre-existing one!");
		sentry = (Self*)this;
	}
	virtual ~singleton()
	{
		if(sentry == this)
			sentry = 0;
	}
};
template <typename Self>
Self*
	singleton<Self>::sentry = 0;

/*
	Example usage:
*/

#include <iostream>
#include <string>

using namespace
	std;

class controller : public singleton<controller>
{
public:
	controller(string const& name)
	: name(name)
	{
		trace("begin");
	}
	~controller()
	{
		trace("end");
	}
	void
		work()
	{
		trace("doing stuff");
	}
	void
		trace(string const& message)
	{
		cout << name << ": " << message << endl;
	}
	string
		name;
};
int
	main()
{
	controller*
		first = new controller("first");
	controller::instance().work();
	delete first;
/*
	No problem, our first controller no longer exists...
*/	
	controller
		second("second");
	controller::instance().work();
	try
	{
	/*
		Never happens...
	*/
		controller
			goner("goner");
		controller::instance().work();
	}
	catch(exception const& error)
	{
		cout << error.what() << endl;
	}
	controller::instance().work();
/*
	Never happens (and depending on your system this may or may not print a helpful message!)
*/
	controller
		goner("goner");
	controller::instance().work();
}

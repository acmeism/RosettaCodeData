#include <Core/Core.h>

using namespace Upp;

CONSOLE_APP_MAIN
{
	FileIn in(CommandLine()[0]);
	while(in && !in.IsEof())
		Cout().PutLine(in.GetLine());
}

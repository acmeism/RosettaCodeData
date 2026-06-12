all: scriptedmain test
	./scriptedmain
	./test

scriptedmain: scriptedmain.cpp scriptedmain.h
	g++ -o scriptedmain -static-libgcc -static-libstdc++ -DSCRIPTEDMAIN scriptedmain.cpp scriptedmain.h

test: test.cpp scriptedmain.h scriptedmain.cpp
	g++ -o test -static-libgcc -static-libstdc++ test.cpp scriptedmain.cpp scriptedmain.h

clean:
	-rm scriptedmain
	-rm test
	-rm scriptedmain.exe
	-rm test.exe

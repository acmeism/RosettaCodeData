all: scriptedmain

scriptedmain: scriptedmain.rs
	rustc scriptedmain.rs

test: test.rs scriptedmain.rs
	rustc --lib scriptedmain.rs
	rustc test.rs -L .

clean:
	-rm test
	-rm -rf *.dylib
	-rm scriptedmain
	-rm -rf *.dSYM

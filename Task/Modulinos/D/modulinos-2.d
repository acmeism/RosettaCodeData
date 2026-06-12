#!/usr/bin/env rdmd -version=test

import scriptedmain;
import std.stdio;

version (test) {
	void main(string[] args) {
		writeln("Test: The meaning of life is ", meaningOfLife());
	}
}

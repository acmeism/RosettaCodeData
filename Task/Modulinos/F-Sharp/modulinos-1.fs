$ make
fsharpc --out:scriptedmain.exe ScriptedMain.fs
fsharpc --out:test.exe ScriptedMain.fs Test.fs
$ mono scriptedmain.exe
Main: The meaning of life is 42
$ mono test.exe
Test: The meaning of life is 42

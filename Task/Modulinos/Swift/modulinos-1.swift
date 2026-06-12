$ make
mkdir -p bin/
swiftc -D SCRIPTEDMAIN -o bin/ScriptedMain ScriptedMain.swift
swiftc -emit-library -module-name ScriptedMain -emit-module ScriptedMain.swift
mkdir -p bin/
swiftc -D TEST -o bin/Test Test.swift -I "." -L "." -lScriptedMain -module-link-name ScriptedMain
bin/ScriptedMain
Main: The meaning of life is 42
bin/Test
Test: The meaning of life is 42

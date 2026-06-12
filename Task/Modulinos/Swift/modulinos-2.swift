all: bin/ScriptedMain bin/Test
	bin/ScriptedMain
	bin/Test

bin/ScriptedMain: ScriptedMain.swift
	mkdir -p bin/
	swiftc -D SCRIPTEDMAIN -o bin/ScriptedMain ScriptedMain.swift

ScriptedMain.swiftmodule: ScriptedMain.swift
	swiftc -emit-library -module-name ScriptedMain -emit-module ScriptedMain.swift

bin/Test: Test.swift ScriptedMain.swiftmodule
	mkdir -p bin/
	swiftc -D TEST -o bin/Test Test.swift -I "." -L "." -lScriptedMain -module-link-name ScriptedMain

clean:
	-rm -rf bin/
	-rm *.swiftmodule
	-rm *.swiftdoc
	-rm *.dylib

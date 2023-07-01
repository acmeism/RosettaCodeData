import 'dart:ffi'
show DynamicLibrary, NativeFunction, Int32;

main(){
	final lib = DynamicLibrary.open('add.dylib'); // Load library

	final int Function(int num1,int num2) add = lib // Write Dart function binding
		.lookup<NativeFunction<Int32 Function( Int32, Int32 )>>('add') // Lookup function in library
		.asFunction(); // convert to Dart Function

	print( add( 1, 2 ) );
}

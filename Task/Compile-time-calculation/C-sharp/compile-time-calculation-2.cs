.class public auto ansi abstract sealed beforefieldinit Program
	extends [System.Runtime]System.Object
{
	// Fields
	.field public static literal int32 FACTORIAL_10 = int32(3628800)

	// Methods
	.method private hidebysig static
		void Main () cil managed
	{
		// Method begins at RVA 0x2050
		// Code size 11 (0xb)
		.maxstack 8
		.entrypoint

		IL_0000: ldc.i4 3628800
		IL_0005: call void [System.Console]System.Console::WriteLine(int32)
		IL_000a: ret
	} // end of method Program::Main

} // end of class Program

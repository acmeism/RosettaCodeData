.class private auto ansi sealed Program
	extends [System.Runtime]System.Object
{
	.custom instance void Microsoft.VisualBasic.CompilerServices.StandardModuleAttribute::.ctor() = (
		01 00 00 00
	)
	// Fields
	.field private static literal int32 FACTORIAL_10 = int32(3628800)

	// Methods
	.method public static
		void Main () cil managed
	{
		.custom instance void [System.Runtime]System.STAThreadAttribute::.ctor() = (
			01 00 00 00
		)
		// Method begins at RVA 0x2060
		// Code size 11 (0xb)
		.maxstack 8
		.entrypoint

		IL_0000: ldc.i4 3628800
		IL_0005: call void [System.Console]System.Console::WriteLine(int32)
		IL_000a: ret
	} // end of method Program::Main

} // end of class Program

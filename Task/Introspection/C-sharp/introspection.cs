using System;
using System.Reflection;

namespace Rosetta_Introspection
{
	static public class Program
	{
		static public int bloop = -10;
		static public int bloop2 = -20;

		public static void Main()
		{
			var asm = Assembly.GetExecutingAssembly();
			var version = int.Parse(asm.ImageRuntimeVersion.Split('.')[0].Substring(1));
			if (version < 4)
			{
				Console.WriteLine("Get with the program!  I'm outta here!");
				return;
			}

			FieldInfo bloopField = null;

			foreach (var type in asm.GetExportedTypes())
			{
				foreach (var field in type.GetFields())
				{
					if (field.Name != "bloop")
					{
						continue;
					}
					bloopField = field;
					if (bloopField.FieldType != typeof(int))
					{
						throw new InvalidProgramException("bloop should be an integer");
					}
					break;
				}
				if (bloopField != null)
				{
					break;
				}
			}

			if (bloopField == null)
			{
				throw new InvalidProgramException("No bloop exported value");
			}
			foreach (var refAsm in AppDomain.CurrentDomain.GetAssemblies())
			{
				foreach (var type in refAsm.GetExportedTypes())
				{
					if (type.Name == "Math")
					{
						var absMethod = type.GetMethod("Abs", new Type[] { typeof(int) });
						if (absMethod != null)
						{
							Console.WriteLine("bloop's abs value = {0}", absMethod.Invoke(null, new object[] { bloopField.GetValue(null) }));
						}
					}
				}
			}

			int intCount = 0;
			int total = 0;

			foreach (var type in asm.GetExportedTypes())
			{
				foreach (var field in type.GetFields())
				{
					if (field.FieldType == typeof(int))
					{
						intCount++;
						total += (int)field.GetValue(null);
					}
				}
			}
			Console.WriteLine("{0} exported ints which total to {1}", intCount, total);
			Console.ReadKey();
		}
	}
}

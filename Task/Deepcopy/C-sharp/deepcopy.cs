using System;

namespace prog
{
	class MainClass
	{
		class MyClass : ICloneable
		{
			public MyClass() { f = new int[3]{2,3,5}; c = '1'; }
			
			public object Clone()
			{				
				MyClass cpy = (MyClass) this.MemberwiseClone();
				cpy.f = (int[]) this.f.Clone();			
				return cpy;
			}
			
			public char c;
			public int[] f;
		}
		
		public static void Main( string[] args )
		{
			MyClass c1 = new MyClass();
			MyClass c2 = (MyClass) c1.Clone();
		}
	}
}

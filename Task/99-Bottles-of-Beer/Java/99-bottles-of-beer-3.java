public class Beer
{
	public static void main(String args[])
	{
		song(99);	
	}
	
	public static void song(int b)
	{
		if(b>=0)
		{
			if(b>1)
			System.out.println(b+" bottles of beer on the wall\n"+b+" bottles of beer\nTake one down, pass it around\n"+(b-1)+" bottles of beer on the wall.\n");	
			else if(b==1)
			System.out.println(b+" bottle of beer on the wall\n"+b+" bottle of beer\nTake one down, pass it around\n"+(b-1)+" bottles of beer on the wall.\n");
			else
			System.out.println(b+" bottles of beer on the wall\n"+b+" bottles of beer\nBetter go to the store and buy some more!");
			song(b-1);
		}	
	}
}

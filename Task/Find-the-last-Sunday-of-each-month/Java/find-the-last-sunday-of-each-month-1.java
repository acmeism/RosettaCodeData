import java.util.Scanner;

public class LastSunday
{
	static final String[] months={"January","February","March","April","May","June","July","August","September","October","November","December"};
	
	public static int[] findLastSunday(int year)
	{
		boolean isLeap = isLeapYear(year);
		
		int[] days={31,isLeap?29:28,31,30,31,30,31,31,30,31,30,31};
		int[] lastDay=new int[12];
		
		for(int m=0;i<12;i++)
		{
			int d;
			for(d=days[m]; getWeekDay(year,m,d)!=0; d--)
				;
			lastDay[m]=d;
		}
		
		return lastDay;
	}
	
	private static boolean isLeapYear(int year)
	{
		if(year%4==0)
		{
			if(year%100!=0)
				return true;
			else if (year%400==0)
				return true;
		}
		return false;
	}
	
	private static int getWeekDay(int y, int m, int d)
	{
		int f=y+d+3*m-1;
		m++;
		
		if(m<3)
			y--;
		else
			f-=(int)(0.4*m+2.3);
		
		f+=(int)(y/4)-(int)((y/100+1)*0.75);
		f%=7;
		
		return f;
	}
	
	private static void display(int year, int[] lastDay)
	{
		System.out.println("\nYEAR: "+year);
		for(int m=0;i<12;i++)
			System.out.println(months[m]+": "+lastDay[m]);
	}
	
	public static void main(String[] args) throws Exception
	{
		System.out.print("Enter year: ");
		Scanner s=new Scanner(System.in);
		
		int y=Integer.parseInt(s.next());
		
		int[] lastDay = findLastSunday(y);
		display(y, lastDay);
		
		s.close();
	}
}

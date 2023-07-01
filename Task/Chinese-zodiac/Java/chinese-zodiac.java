public class Zodiac {

	final static String animals[]={"Rat","Ox","Tiger","Rabbit","Dragon","Snake","Horse","Goat","Monkey","Rooster","Dog","Pig"};
	final static String elements[]={"Wood","Fire","Earth","Metal","Water"};
	final static String animalChars[]={"子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥"};
	static String elementChars[][]={{"甲","丙","戊","庚","壬"},{"乙","丁","己","辛","癸"}};

	static String getYY(int year)
	{
	    if(year%2==0)
	    {
	        return "yang";
	    }
	    else
	    {
	        return "yin";
	    }
	}

	public static void main(String[] args)
	{
		int years[]={1935,1938,1968,1972,1976,1984,1985,2017};
		for(int i=0;i<years.length;i++)
		{
			System.out.println(years[i]+" is the year of the "+elements[(int) Math.floor((years[i]-4)%10/2)]+" "+animals[(years[i]-4)%12]+" ("+getYY(years[i])+"). "+elementChars[years[i]%2][(int) Math.floor((years[i]-4)%10/2)]+animalChars[(years[i]-4)%12]);
		}
	}
}

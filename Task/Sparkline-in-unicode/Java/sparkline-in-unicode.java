public class Sparkline
{
	String bars="▁▂▃▄▅▆▇█";
	public static void main(String[] args)
	{
		Sparkline now=new Sparkline();
		float[] arr={1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1};
		now.display1D(arr);
		System.out.println(now.getSparkline(arr));
		float[] arr1={1.5f, 0.5f, 3.5f, 2.5f, 5.5f, 4.5f, 7.5f, 6.5f};
		now.display1D(arr1);
		System.out.println(now.getSparkline(arr1));
	}
	public void display1D(float[] arr)
	{
		for(int i=0;i<arr.length;i++)
			System.out.print(arr[i]+" ");
		System.out.println();
	}
	public String getSparkline(float[] arr)
	{
		float min=Integer.MAX_VALUE;
		float max=Integer.MIN_VALUE;
		for(int i=0;i<arr.length;i++)
		{
			if(arr[i]<min)
				min=arr[i];
			if(arr[i]>max)
				max=arr[i];
		}
		float range=max-min;
		int num=bars.length()-1;
		String line="";
		for(int i=0;i<arr.length;i++)
		{
			
			line+=bars.charAt((int)Math.ceil(((arr[i]-min)/range*num)));
		}
		return line;
	}
}

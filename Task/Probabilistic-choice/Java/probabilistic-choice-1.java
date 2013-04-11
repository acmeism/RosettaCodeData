public class Prob{
	static long TRIALS= 1000000;

	private static class Expv{
		public String name;
		public int probcount;
		public double expect;
		public double mapping;

		public Expv(String name, int probcount, double expect, double mapping){
			this.name= name;
			this.probcount= probcount;
			this.expect= expect;
			this.mapping= mapping;
		}
	}

	static Expv[] items=
			{new Expv("aleph", 0, 0.0, 0.0), new Expv("beth", 0, 0.0, 0.0),
					new Expv("gimel", 0, 0.0, 0.0),
					new Expv("daleth", 0, 0.0, 0.0),
					new Expv("he", 0, 0.0, 0.0), new Expv("waw", 0, 0.0, 0.0),
					new Expv("zayin", 0, 0.0, 0.0),
					new Expv("heth", 0, 0.0, 0.0)};

	public static void main(String[] args){
		int i, j;
		double rnum, tsum= 0.0;

		for(i= 0, rnum= 5.0;i < 7;i++, rnum+= 1.0){
			items[i].expect= 1.0 / rnum;
			tsum+= items[i].expect;
		}
		items[7].expect= 1.0 - tsum;

		items[0].mapping= 1.0 / 5.0;
		for(i= 1;i < 7;i++){
			items[i].mapping= items[i - 1].mapping + 1.0 / ((double)i + 5.0);
		}
		items[7].mapping= 1.0;


		for(i= 0;i < TRIALS;i++){
			rnum= Math.random();
			for(j= 0;j < 8;j++){
				if(rnum < items[j].mapping){
					items[j].probcount++;
					break;
				}
			}
		}

		System.out.printf("Trials: %d\n", TRIALS);
		System.out.printf("Items:          ");
		for(i= 0;i < 8;i++)
			System.out.printf("%-8s ", items[i].name);
		System.out.printf("\nTarget prob.:   ");
		for(i= 0;i < 8;i++)
			System.out.printf("%8.6f ", items[i].expect);
		System.out.printf("\nAttained prob.: ");
		for(i= 0;i < 8;i++)
			System.out.printf("%8.6f ", (double)(items[i].probcount)
					/ (double)TRIALS);
		System.out.printf("\n");

	}
}

import java.util.EnumMap;

public class Prob {
	public static long TRIALS= 1000000;
	public enum Glyph{
		ALEPH, BETH, GIMEL, DALETH, HE, WAW, ZAYIN, HETH;
	}
	
	public static EnumMap<Glyph, Double> probs = new EnumMap<Glyph, Double>(Glyph.class){{
		put(Glyph.ALEPH,   1/5.0);
		put(Glyph.BETH,    1/6.0);
		put(Glyph.GIMEL,   1/7.0);
		put(Glyph.DALETH,  1/8.0);
		put(Glyph.HE,      1/9.0);
		put(Glyph.WAW,     1/10.0);
		put(Glyph.ZAYIN,   1/11.0);
		put(Glyph.HETH,    1759./27720);
	}};
	
	public static EnumMap<Glyph, Double> counts = new EnumMap<Glyph, Double>(Glyph.class){{
		put(Glyph.ALEPH, 0.);put(Glyph.BETH,   0.);
		put(Glyph.GIMEL, 0.);put(Glyph.DALETH, 0.);
		put(Glyph.HE,    0.);put(Glyph.WAW,    0.);
		put(Glyph.ZAYIN, 0.);put(Glyph.HETH,   0.);
	}};
	
	public static void main(String[] args){
		System.out.println("Target probabliities:\t" + probs);
		for(long i = 0; i < TRIALS; i++){
			Glyph choice = getChoice();
			counts.put(choice, counts.get(choice) + 1);
		}

		//correct the counts to probablities in (0..1]
		for(Glyph glyph:counts.keySet()){
			counts.put(glyph, counts.get(glyph) / TRIALS);
		}
		
		System.out.println("Actual probabliities:\t" + counts);
	}
	
	private static Glyph getChoice() {
		double rand = Math.random();
		for(Glyph item:Glyph.values()){
			if(rand < probs.get(item)){
				return item;
			}
			rand -= probs.get(item);
		}
		return null;
	}
}

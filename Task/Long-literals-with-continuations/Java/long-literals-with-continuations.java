import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;

public final class LongLiteralsWithContinuations {

	public static void main(String[] aArgs) {
		ZoneId zoneID = ZoneId.of("Asia/Shanghai");
		ZonedDateTime zonedDateTime = ZonedDateTime.now(zoneID);		
		String dateTime = zonedDateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss a"));
		
		List<String> elements = splitToList(ELEMENTS).stream().
			filter( s -> ! splitToList(UNNAMED_ELEMENTS).contains(s) ).toList();
				
	    System.out.println("Last revision Date:  " + dateTime + " " + zoneID);
	    System.out.println("Number of elements:  " + elements.size());
	    System.out.println("Last element      :  " + elements.get(elements.size() - 1));
	}
	
	private static List<String> splitToList(String aText) {
		String excessWhiteSpaceRemoved = aText.trim().replaceAll("\\s+", " ");
		return Arrays.stream(excessWhiteSpaceRemoved.split(" ")).toList();
	}
	
	private static final String ELEMENTS = """
		hydrogen     helium        lithium      beryllium
		boron        carbon        nitrogen     oxygen
		fluorine     neon          sodium       magnesium
		aluminum     silicon       phosphorous  sulfur
		chlorine     argon         potassium    calcium
		scandium     titanium      vanadium     chromium
		manganese    iron          cobalt       nickel
		copper       zinc          gallium      germanium
		arsenic      selenium      bromine      krypton
		rubidium     strontium     yttrium      zirconium
		niobium      molybdenum    technetium   ruthenium
		rhodium      palladium     silver       cadmium
		indium       tin           antimony     tellurium
		iodine       xenon         cesium       barium
		lanthanum    cerium        praseodymium neodymium
		promethium   samarium      europium     gadolinium
		terbium      dysprosium    holmium      erbium
		thulium      ytterbium     lutetium     hafnium
		tantalum     tungsten      rhenium      osmium
		iridium      platinum      gold         mercury
		thallium     lead          bismuth      polonium
		astatine     radon         francium     radium
		actinium     thorium       protactinium uranium
		neptunium    plutonium     americium    curium
		berkelium    californium   einsteinium  fermium
		mendelevium  nobelium      lawrencium   rutherfordium
		dubnium      seaborgium    bohrium      hassium
		meitnerium   darmstadtium  roentgenium  copernicium
		nihonium     flerovium     moscovium    livermorium
		tennessine   oganesson
		""";
	
	private static final String UNNAMED_ELEMENTS = """
		ununennium     unquadnilium triunhexium penthextrium
		penthexpentium septhexunium octenntrium ennennbium
		""";
	
}

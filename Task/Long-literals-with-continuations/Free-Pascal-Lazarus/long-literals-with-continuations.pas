program longStringLiteralDemo(output);

{$mode objFPC}
{$longStrings on}

uses
	// for `format`
	sysUtils,
	// for `wordCount` and `extractWord`
	strUtils;

const
	elementString = 'hydrogen helium lithium beryllium boron carbon nitrogen oxy' +
		'gen fluorine neon sodium magnesium aluminum silicon phosphorous sulfur chl' +
		'orine argon potassium calcium scandium titanium vanadium chromium manganes' +
		'e iron cobalt nickel copper zinc gallium germanium arsenic selenium bromin' +
		'e krypton rubidium strontium yttrium zirconium niobium molybdenum techneti' +
		'um ruthenium rhodium palladium silver cadmium indium tin antimony telluriu' +
		'm iodine xenon cesium barium lanthanum cerium praseodymium neodymium prome' +
		'thium samarium europium gadolinium terbium dysprosium holmium erbium thuli' +
		'um ytterbium lutetium hafnium tantalum tungsten rhenium osmium iridium pla' +
		'tinum gold mercury thallium lead bismuth polonium astatine radon francium ' +
		'radium actinium thorium protactinium uranium neptunium plutonium americium' +
		' curium berkelium californium einsteinium fermium mendelevium nobelium law' +
		'rencium rutherfordium dubnium seaborgium bohrium hassium meitnerium darmst' +
		'adtium roentgenium copernicium nihonium flerovium moscovium livermorium te' +
		'nnessine oganesson';
	elementRevision = '2020‑11‑11';

resourcestring
	revisionNotice = 'Last update: %0:s';

begin
	writeLn(format(revisionNotice, [elementRevision]));
	writeLn(wordCount(elementString, stdWordDelims));
	writeLn(extractWord(wordCount(elementString, stdWordDelims),
		elementString, stdWordDelims));
end.

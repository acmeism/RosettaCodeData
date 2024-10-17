program Long_literals_with_continuations;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.StrUtils;

// Copy and past of Free_Pascal version
const
  StdWordDelims: array[0..16] of char = (#0, ' ', ',', '.', ';', '/', '\', ':',
    '''', '"', '`', '(', ')', '[', ']', '{', '}');
  revisionNotice = 'Last update: %0:s';

  elementString = 'hydrogen helium lithium beryllium boron carbon nitrogen oxy'
    + 'gen fluorine neon sodium magnesium aluminum silicon phosphorous sulfur chl'
    + 'orine argon potassium calcium scandium titanium vanadium chromium manganes'
    + 'e iron cobalt nickel copper zinc gallium germanium arsenic selenium bromin'
    + 'e krypton rubidium strontium yttrium zirconium niobium molybdenum techneti'
    + 'um ruthenium rhodium palladium silver cadmium indium tin antimony telluriu'
    + 'm iodine xenon cesium barium lanthanum cerium praseodymium neodymium prome'
    + 'thium samarium europium gadolinium terbium dysprosium holmium erbium thuli'
    + 'um ytterbium lutetium hafnium tantalum tungsten rhenium osmium iridium pla'
    + 'tinum gold mercury thallium lead bismuth polonium astatine radon francium '
    + 'radium actinium thorium protactinium uranium neptunium plutonium americium'
    + ' curium berkelium californium einsteinium fermium mendelevium nobelium law'
    + 'rencium rutherfordium dubnium seaborgium bohrium hassium meitnerium darmst'
    + 'adtium roentgenium copernicium nihonium flerovium moscovium livermorium te'
    + 'nnessine oganesson';
  elementRevision = '2020-11-11';

begin
  var words := elementString.Split(StdWordDelims);

  writeLn(format(revisionNotice, [elementRevision]));
  writeln(length(words));
  writeln(words[high(words)]);
  readln;
end.

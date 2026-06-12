# Construct the mapping variables from the source mapping
apply {{} {
    global genderMap genderRE
    # The mapping is from the Python solution, though omitting the names
    # for the sake of a bit of brevity...
    foreach {maleTerm femaleTerm} {
	maleS femaleS  maleness femaleness
	him her  himself herself  his hers  his her  he she
	Mr Mrs  Mister Missus  Ms Mr  Master Miss  Master Mistress
	uncleS auntS  nephewS nieceS  sonS daughterS  grandsonS granddaughterS
	brotherS sisterS  man woman  men women  boyS girlS  paternal maternal
	grandfatherS grandmotherS  GodfatherS GodmotherS  GodsonS GoddaughterS
	fiancéS fiancéeS  husband wife  husbands wives  fatherS motherS
	bachelorS spinsterS  bridegroomS brideS  widowerS widowS
	KnightS DameS  Sir DameS  KingS QueenS  DukeS DuchessES
	PrinceS PrincessES  Lord Lady  Lords Ladies  MarquessES MarchionessES
	EarlS CountessES  ViscountS ViscountessES  ladS lassES  sir madam
	gentleman lady  gentlemen ladies  BaronS BaronessES
	stallionS mareS  ramS eweS  coltS fillieS  billy nanny  billies nannies
	bullS cowS  godS goddessES  heroS heroineS  shirtS blouseS  undies nickers
	sweat glow  jackarooS jillarooS  gigoloS hookerS  landlord landlady
	landlords landladies  manservantS maidservantS  actorS actressES
	CountS CountessES  EmperorS EmpressES  giantS giantessES  heirS heiressES
	hostS hostessES  lionS lionessES  managerS manageressES
	murdererS murderessES  priestS priestessES  poetS poetessES
	shepherdS shepherdessES  stewardS stewardessES  tigerS tigressES
	waiterS waitressES  cockS henS  dogS bitchES  drakeS henS  dogS vixenS
	tomS tibS  boarS sowS  buckS roeS  peacockS peahenS
	gander goose  ganders geese  friarS nunS  monkS nunS
    } {
	foreach {m f} [list \
	    $maleTerm $femaleTerm \
	    [regsub {E*S$} $maleTerm ""] [regsub {E*S$} $femaleTerm ""]
	] {
	    dict set genderMap [string tolower $m] [string tolower $f]
	    dict set genderMap [string toupper $m] [string toupper $f]
	    dict set genderMap [string totitle $m] [string totitle $f]
	    dict set genderMap [string tolower $f] [string tolower $m]
	    dict set genderMap [string toupper $f] [string toupper $m]
	    dict set genderMap [string totitle $f] [string totitle $m]
	}
    }
    # Now the RE, which matches any key in the map *as a word*
    set genderRE "\\m(?:[join [dict keys $genderMap] |])\\M"
}}

proc reverseGender {string} {
    global genderRE genderMap
    # Used to disable Tcl's metacharacters for [subst]
    set safetyMap {\\ \\\\ \[ \\\[ \] \\\] $ \\$}
    subst [regsub -all $genderRE [string map $safetyMap $string] {[
	string map $genderMap &
    ]}]
}

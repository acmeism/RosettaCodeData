string[] bottles = { 	"80 Shilling",
			"Abita Amber",
			"Adams Broadside Ale",
			"Altenmünster Premium",
			"August Schell's SnowStorm",
			"Bah Humbug! Christmas Ale",
			"Beck's Oktoberfest",
			"Belhaven Wee Heavy",
			"Bison Chocolate Stout",
			"Blue Star Wheat Beer",
			"Bridgeport Black Strap Stout",
			"Brother Thelonius Belgian-Style Abbey Ale",
			"Capital Blonde Doppelbock",
			"Carta Blanca",
			"Celis Raspberry Wheat",
			"Christian Moerlein Select Lager",
			"Corona",
			"Czechvar",
			"Delirium Tremens",
			"Diamond Bear Southern Blonde",
			"Don De Dieu",
			"Eastside Dark",
			"Eliot Ness",
			"Flying Dog K-9 Cruiser Altitude Ale",
			"Fuller's London Porter",
			"Gaffel Kölsch",
			"Golden Horseshoe",
			"Guinness Pub Draught",
			"Hacker-Pschorr Weisse",
			"Hereford & Hops Black Spring Double Stout",
			"Highland Oatmeal Porter",
			"Ipswich Ale",
			"Iron City",
			"Jack Daniel's Amber Lager",
			"Jamaica Sunset India Pale Ale",
			"Killian's Red",
			"König Ludwig Weiss",
			"Kronenbourg 1664",
			"Lagunitas Hairy Eyball Ale",
			"Left Hand Juju Ginger",
			"Locktender Lager",
			"Magic Hat Blind Faith",
			"Missing Elf Double Bock",
			"Muskoka Cream Ale ",
			"New Glarus Cherry Stout",
			"Nostradamus Bruin",
			"Old Devil",
			"Ommegang Three Philosophers",
			"Paulaner Hefe-Weizen Dunkel",
			"Perla Chmielowa Pils",
			"Pete's Wicked Springfest",
			"Point White Biere",
			"Prostel Alkoholfrei",
			"Quilmes",
			"Rahr's Red",
			"Rebel Garnet",
			"Rickard's Red",
			"Rio Grande Elfego Bock",
			"Rogue Brutal Bitter",
			"Roswell Alien Amber Ale",
			"Russian River Pliny The Elder",
			"Samuel Adams Blackberry Witbier",
			"Samuel Smith's Taddy Porter",
			"Schlafly Pilsner",
			"Sea Dog Wild Blueberry Wheat Ale",
			"Sharp's",
			"Shiner 99",
			"Sierra Dorada",
			"Skullsplitter Orkney Ale",
			"Snake Chaser Irish Style Stout",
			"St. Arnold Bock",
			"St. Peter's Cream Stout",
			"Stag",
			"Stella Artois",
			"Stone Russian Imperial Stout",
			"Sweetwater Happy Ending Imperial Stout",
			"Taiwan Gold Medal",
			"Terrapin Big Hoppy Monster",
			"Thomas Hooker American Pale Ale",
			"Tie Die Red Ale",
			"Toohey's Premium",
			"Tsingtao",
			"Ugly Pug Black Lager",
			"Unibroue Qatre-Centieme",
			"Victoria Bitter",
			"Voll-Damm Doble Malta",
			"Wailing Wench Ale",
			"Warsteiner Dunkel",
			"Wellhead Crude Oil Stout",
			"Weyerbacher Blithering Idiot Barley-Wine Style Ale",
			"Wild Boar Amber",
			"Würzburger Oktoberfest",
			"Xingu Black Beer",
			"Yanjing",
			"Younger's Tartan Special",
			"Yuengling Black & Tan",
			"Zagorka Special",
			"Zig Zag River Lager",
			"Zywiec" };


int bottlesLeft = 99;
const int FIRST_LINE_SINGULAR = 98;
const int FINAL_LINE_SINGULAR = 97;
string firstLine = "";
string finalLine = "";


for (int i = 0; i < 99; i++)
{
	firstLine = bottlesLeft.ToString() + " bottle";
	if (i != FIRST_LINE_SINGULAR)
	    firstLine += "s";
	firstLine += " of beer on the wall, " + bottlesLeft.ToString() + " bottle";
	if (i != FIRST_LINE_SINGULAR)
	    firstLine += "s";
	firstLine += " of beer";

	Console.WriteLine(firstLine);
	Console.WriteLine("Take the " + bottles[i] + " down, pass it around,");
	bottlesLeft--;

	finalLine = bottlesLeft.ToString() + " bottle";
	if (i != FINAL_LINE_SINGULAR)
	    finalLine += "s";
	finalLine += " of beer on the wall!";

	Console.WriteLine(finalLine);
	Console.WriteLine();
	Console.ReadLine();
}

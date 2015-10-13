module bottles;

template BeerSong(int Bottles)
{
	static if (Bottles == 1)
	{
		enum BeerSong = "1 bottle of beer on the wall\n" ~
		"1 bottle of beer\ntake it down, pass it around\n" ~ "
		no more bottles of beer on the wall\n";
	}
	else
	{
		enum BeerSong = Bottles.stringof ~ " bottles of beer on the wall\n" ~
		Bottles.stringof ~ " bottles of beer\ntake it down, pass it around\n" ~
		BeerSong!(Bottles-1);
	}
}

pragma(msg,BeerSong!99);

void main(){}

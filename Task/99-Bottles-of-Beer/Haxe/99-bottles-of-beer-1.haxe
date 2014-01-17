class RosettaDemo
{
    static public function main()
    {
        singBottlesOfBeer(100);
    }

    static function singBottlesOfBeer(bottles : Int)
    {
        var plural : String = 's';

        while (bottles >= 1)
        {
            Sys.println(bottles + " bottle" + plural + " of beer on the wall,");
            Sys.println(bottles + " bottle" + plural + " of beer!");
            Sys.println("Take one down, pass it around,");
            if (bottles - 1 == 1)
            {
                plural = '';
            }

            if (bottles > 1)
            {
                Sys.println(bottles-1 + " bottle" + plural + " of beer on the wall!\n");
            }
            else
            {
                Sys.println("No more bottles of beer on the wall!");
            }
            bottles--;
        }
    }
}

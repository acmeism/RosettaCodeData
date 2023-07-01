public class NinetyNineBottles{
    public static def main(args: Rail[String]){
        val beerSong: NinetyNineBottles = NinetyNineBottles.make(99);
        beerSong.create();
        beerSong.sing();
    }
    var numVerses: Int;
    var verses: Array[String]{rank==1};
    var bottles: Int;

    public static def make(var numBottles: Int){
        val s = new NinetyNineBottles();
        s.numVerses = numBottles + 1;
        val verses: Region{rank==1} = [1..s.numVerses];
        s.verses = Array.make[String](verses, (Point) => new String());
        s.bottles = numBottles;
        return s;
    }

    public def create(){
        finish ateach ( (p):Point in verses ){
            val wallCount = bottles - p + 1;
            verses(p) = createVerse( p ) ;
        }
        return;
    }

    public def sing(){
        for ( (p):Point in verses ){
            Console.OUT.println(verses(p));
        }
        return;
    }

    public def createVerse(var verseNum: Int): String{
        val lineA:String,
            lineB:String;
        val wallCount = bottles - (verseNum - 1);
        val nextWallCount = (wallCount + numVerses - 1)%numVerses;

        if (wallCount > 0) {
            lineA = line(wallCount);
            lineB = lineA;
        }else{
            lineA = "No " + line(wallCount);
            lineB = "no " + line(wallCount);
        }
        return lineA + " on the wall, " + lineB + ".\n" +
            action(wallCount) + line(nextWallCount) + " on the wall.\n";
    }

    public static def line(val numBottles:Int):String{

        switch(numBottles){
            case 0:    return "more bottles of beer";
            case 1:    return numBottles + " bottle of beer";
            default:    return numBottles + " bottles of beer";
      }
  }

    public static def action(val numBottles:Int):String{
        if (numBottles==0)
            return "Go to the store and buy some more, ";
        else
            return "Take one down and pass it around, ";
    }
}

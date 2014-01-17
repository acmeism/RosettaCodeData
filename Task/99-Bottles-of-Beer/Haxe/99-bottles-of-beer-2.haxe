class Bottles {

    static public function main () : Void {
        singBottlesOfBeer(100);
    }


    macro static public function singBottlesOfBeer (bottles:Int) {
        var lines = [];
        var s : String = 's';

        var song : String = '';
        while( bottles >= 1 ){
            song += '$bottles bottle$s of beer on the wall,\n';
            song += '$bottles bottle$s of beer!\n';
            song += 'Take one down, pass it around,\n';

            bottles --;

            if( bottles > 1 ){
                song += '$bottles bottles of beer on the wall!\n\n';
            }else if( bottles == 1 ){
                s = '';
                song += '$bottles bottle of beer on the wall!\n\n';
            }else{
                song += 'No more bottles of beer on the wall!\n';
            }
        }

        return macro Sys.print($v{song});
    }

}

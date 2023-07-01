public class Immute{
    private final int num;
    private final String word;
    private final StringBuffer buff; //still mutable inside this class, but there is no access outside this class

    public Immute(int num){
        this.num = num;
        word = num + "";
        buff = new StringBuffer("test" + word);
    }

    public int getNum(){
        return num;
    }

    public String getWord(){
        return word; //String objects are immutable so passing the object back directly won't harm anything
    }

    public StringBuffer getBuff(){
        return new StringBuffer(buff);
        //using "return buff" here compromises immutability, but copying the object via the constructor makes it ok
    }
    //no "set" methods are given
}

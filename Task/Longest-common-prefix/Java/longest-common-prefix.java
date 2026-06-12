public class LCP {
    public static String lcp(String... list){
        if(list == null) return "";//special case
        String ret = "";
        int idx = 0;

        while(true){
            char thisLetter = 0;
            for(String word : list){
                if(idx == word.length()){ //if we reached the end of a word then we are done
                    return ret;
                }
                if(thisLetter == 0){ //if this is the first word then note the letter we are looking for
                    thisLetter = word.charAt(idx);
                }
                if(thisLetter != word.charAt(idx)){ //if this word doesn't match the letter at this position we are done
                    return ret;
                }
            }
            ret += thisLetter;//if we haven't said we are done then this position passed
            idx++;
        }
    }

    public static void main(String[] args){
        System.out.println(lcp("interspecies","interstellar","interstate"));
        System.out.println(lcp("throne","throne"));
        System.out.println(lcp("throne","dungeon"));
        System.out.println(lcp("throne","","throne"));
        System.out.println(lcp("cheese"));
        System.out.println(lcp(""));
        System.out.println(lcp(null));
        System.out.println(lcp("prefix","suffix"));
        System.out.println(lcp("foo","foobar"));
    }
}

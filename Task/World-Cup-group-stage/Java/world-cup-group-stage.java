import java.util.Arrays;

public class GroupStage{
    //team left digit vs team right digit
    static String[] games = {"12", "13", "14", "23", "24", "34"};
    static String results = "000000";//start with left teams all losing

    private static boolean nextResult(){
        if(results.equals("222222")) return false;
        int res = Integer.parseInt(results, 3) + 1;
        results = Integer.toString(res, 3);
        while(results.length() < 6) results = "0" + results;	//left pad with 0s
        return true;
    }

    public static void main(String[] args){
        int[][] points = new int[4][10]; 		//playing 3 games, points range from 0 to 9
        do{
            int[] records = {0,0,0,0};
            for(int i = 0; i < 6; i++){
                switch(results.charAt(i)){
                    case '2': records[games[i].charAt(0) - '1'] += 3; break;    //win for left team
                    case '1':                                                   //draw
                        records[games[i].charAt(0) - '1']++;
                        records[games[i].charAt(1) - '1']++;
                        break;
                    case '0': records[games[i].charAt(1) - '1'] += 3; break;    //win for right team
                }
            }
            Arrays.sort(records);	//sort ascending, first place team on the right
            points[0][records[0]]++;
            points[1][records[1]]++;
            points[2][records[2]]++;
            points[3][records[3]]++;
        }while(nextResult());
        System.out.println("First place: " + Arrays.toString(points[3]));
        System.out.println("Second place: " + Arrays.toString(points[2]));
        System.out.println("Third place: " + Arrays.toString(points[1]));
        System.out.println("Fourth place: " + Arrays.toString(points[0]));
    }
}

import java.util.Collections;
import java.util.List;

public final class ExactlyThreeAdjacent3InLists {

    public static void main(String[] args) {
        List<List<Integer>> lists = List.of( List.of( 9, 3, 3, 3, 2, 1, 7, 8, 5 ),
            List.of( 5, 2, 9, 3, 3, 7, 8, 4, 1 ), List.of( 1, 4, 3, 6, 7, 3, 8, 3, 2 ),
            List.of( 1, 2, 3, 4, 5, 6, 7, 8, 9 ), List.of( 4, 6, 8, 7, 2, 3, 3, 3, 1 )
        );

        lists.forEach( list -> {
            final boolean result = Collections.indexOfSubList(list, List.of( 3, 3, 3 )) != -1;
            System.out.println(list + " => " + result);
        } );
    }

}

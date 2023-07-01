import java.util.*;

class DinesmanMultipleDwelling {

    private static void generatePermutations(String[] apartmentDwellers, Set<String> set, String curPermutation) {
        for (String s : apartmentDwellers) {
            if (!curPermutation.contains(s)) {
                String nextPermutation = curPermutation + s;
                if (nextPermutation.length() == apartmentDwellers.length) {
                    set.add(nextPermutation);
                } else {
                    generatePermutations(apartmentDwellers, set, nextPermutation);
                }
            }
        }
    }

    private static boolean topFloor(String permutation, String person) { //Checks to see if the person is on the top floor
        return permutation.endsWith(person);
    }

    private static boolean bottomFloor(String permutation, String person) {//Checks to see if the person is on the bottom floor
        return permutation.startsWith(person);
    }

    public static boolean livesAbove(String permutation, String upperPerson, String lowerPerson) {//Checks to see if the person lives above the other person
        return permutation.indexOf(upperPerson) > permutation.indexOf(lowerPerson);
    }

    public static boolean adjacent(String permutation, String person1, String person2) { //checks to see if person1 is adjacent to person2
        return (Math.abs(permutation.indexOf(person1) - permutation.indexOf(person2)) == 1);
    }

    private static boolean isPossible(String s) {
        /*
         What this does should be obvious...proper explaination can be given if needed
         Conditions here Switching any of these to ! or reverse will change what is given as a result

         example
         if(topFloor(s, "B"){
         }
         to
         if(!topFloor(s, "B"){
         }
         or the opposite
         if(!topFloor(s, "B"){
         }
         to
         if(topFloor(s, "B"){
         }
         */
        if (topFloor(s, "B")) {//B is on Top Floor
            return false;
        }
        if (bottomFloor(s, "C")) {//C is on Bottom Floor
            return false;
        }
        if (topFloor(s, "F") || bottomFloor(s, "F")) {// F is on top or bottom floor
            return false;
        }
        if (!livesAbove(s, "M", "C")) {// M does not live above C
            return false;
        }
        if (adjacent(s, "S", "F")) { //S lives adjacent to F
            return false;
        }
        return !adjacent(s, "F", "C"); //F does not live adjacent to C
    }

    public static void main(String[] args) {
        Set<String> set = new HashSet<String>();
        generatePermutations(new String[]{"B", "C", "F", "M", "S"}, set, ""); //Generates Permutations
        for (Iterator<String> iterator = set.iterator(); iterator.hasNext();) {//Loops through iterator
            String permutation = iterator.next();
            if (!isPossible(permutation)) {//checks to see if permutation is false if so it removes it
                iterator.remove();
            }
        }
        for (String s : set) {
            System.out.println("Possible arrangement: " + s);
            /*
            Prints out possible arranagement...changes depending on what you change in the "isPossible method"
             */
        }
    }
}

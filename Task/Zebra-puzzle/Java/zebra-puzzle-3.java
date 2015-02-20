package zebra;

import java.util.ArrayList;
import java.util.Iterator;

public class Puzzle {
    private static final ArrayList<Integer> orders = new ArrayList<>(5);
    private static final ArrayList<String> nations = new ArrayList<>(5);
    private static final ArrayList<String> animals = new ArrayList<>(5);
    private static final ArrayList<String> drinks = new ArrayList<>(5);
    private static final ArrayList<String> cigarettes = new ArrayList<>(5);
    private static final ArrayList<String> colors = new ArrayList<>(5);
    private static PuzzleSet<LineOfPuzzle> puzzleTable;
    static
    {
        // House orders
        orders.add(1);
        orders.add(2);
        orders.add(3);
        orders.add(4);
        orders.add(5);
        // Man nations
        nations.add("English");
        nations.add("Danish");
        nations.add("German");
        nations.add("Swedesh");
        nations.add("Norwegian");
        //Animals
        animals.add("Zebra");
        animals.add("Horse");
        animals.add("Birds");
        animals.add("Dog");
        animals.add("Cats");
        //Drinks
        drinks.add("Coffee");
        drinks.add("Tea");
        drinks.add("Beer");
        drinks.add("Water");
        drinks.add("Milk");
        //Smokes
        cigarettes.add("Pall Mall");
        cigarettes.add("Blend");
        cigarettes.add("Blue Master");
        cigarettes.add("Prince");
        cigarettes.add("Dunhill");
        //Colors
        colors.add("Red");
        colors.add("Green");
        colors.add("White");
        colors.add("Blue");
        colors.add("Yellow");
    }

    public static void main (String[] args){
        boolean validLine=true;
        puzzleTable = new PuzzleSet<>();

        //Rules
        LineOfPuzzle rule2 = new LineOfPuzzle(null, "English", "Red", null, null, null);
        LineOfPuzzle rule3 = new LineOfPuzzle(null, "Swedesh", null, "Dog", null, null);
        LineOfPuzzle rule4 = new LineOfPuzzle(null, "Danish", null, null, "Tea", null);
        LineOfPuzzle rule6 = new LineOfPuzzle(null, null, "Green", null, "Coffee", null);
        LineOfPuzzle rule7 = new LineOfPuzzle(null, null, null, "Birds", null, "Pall Mall");
        LineOfPuzzle rule8 = new LineOfPuzzle(null, null, "Yellow", null, null, "Dunhill");
        LineOfPuzzle rule9 = new LineOfPuzzle(3, null, null, null, "Milk", null);
        LineOfPuzzle rule10 = new LineOfPuzzle(1, "Norwegian", null, null, null, null);
        LineOfPuzzle rule13 = new LineOfPuzzle(null, null, null, null, "Beer", "Blue Master");
        LineOfPuzzle rule14 = new LineOfPuzzle(null, "German", null, null, null, "Prince");
        LineOfPuzzle rule15 = new LineOfPuzzle(2, null, "Blue", null, null, null);

        PuzzleSet<LineOfPuzzle> ruleSet = new PuzzleSet<>();
        ruleSet.add(rule2);
        ruleSet.add(rule3);
        ruleSet.add(rule4);
        ruleSet.add(rule6);
        ruleSet.add(rule7);
        ruleSet.add(rule8);
        ruleSet.add(rule9);
        ruleSet.add(rule10);
        ruleSet.add(rule13);
        ruleSet.add(rule14);
        ruleSet.add(rule15);

        //Creating all possible combination of a puzzle line.
        //The maximum number of lines is 5^^6 (15625).
        //Each combination line is checked against a set of knowing facts, thus
        //only a small number of line result at the end.
        for (Integer orderId : Puzzle.orders) {
            for (String nation : Puzzle.nations) {
                for (String color : Puzzle.colors) {
                    for (String animal : Puzzle.animals) {
                        for (String drink : Puzzle.drinks) {
                            for (String cigarette : Puzzle.cigarettes) {
                                LineOfPuzzle pzlLine = new LineOfPuzzle(orderId,
                                                                     nation,
                                                                     color,
                                                                     animal,
                                                                     drink,
                                                                     cigarette);
                                // Checking against a set of knowing facts
                                if (ruleSet.accepts(pzlLine)){
                                        // Adding rules of neighbors
                                        if (cigarette.equalsIgnoreCase("Blend")
                                                && (animal.equalsIgnoreCase("Cats")
                                                || drink.equalsIgnoreCase("Water")))
                                            validLine = false;

                                        if (cigarette.equalsIgnoreCase("Dunhill")
                                                && animal.equalsIgnoreCase("Horse"))
                                            validLine = false;

                                        if (validLine){
                                            puzzleTable.add(pzlLine);

                                            //set neighbors constraints
                                            if (color.equalsIgnoreCase("Green")){
                                                pzlLine.setRightNeighbor(new LineOfPuzzle(null, null, "White", null, null, null));
                                            }
                                            if (color.equalsIgnoreCase("White")){
                                                pzlLine.setLeftNeighbor(new LineOfPuzzle(null, null, "Green", null, null, null));
                                            }
                                            //
                                            if (animal.equalsIgnoreCase("Cats")
                                                    && !cigarette.equalsIgnoreCase("Blend") ){
                                                pzlLine.addUndefindedNeighbor(new LineOfPuzzle(null, null, null, null, null, "Blend"));
                                            }
                                            if (cigarette.equalsIgnoreCase("Blend")
                                                    && !animal.equalsIgnoreCase("Cats")){
                                                pzlLine.addUndefindedNeighbor(new LineOfPuzzle(null, null, null, "Cats", null, null));
                                            }
                                            //
                                            if (drink.equalsIgnoreCase("Water")
                                                    && !animal.equalsIgnoreCase("Cats")
                                                    && !cigarette.equalsIgnoreCase("Blend")){
                                                pzlLine.addUndefindedNeighbor(new LineOfPuzzle(null, null, null, null, null, "Blend"));
                                            }

                                            if (cigarette.equalsIgnoreCase("Blend")
                                                    && !drink.equalsIgnoreCase("Water")){
                                                pzlLine.addUndefindedNeighbor(new LineOfPuzzle(null, null, null, null, "Water", null));
                                            }
                                            //
                                            if (animal.equalsIgnoreCase("Horse")
                                                    && !cigarette.equalsIgnoreCase("Dunhill")){
                                                pzlLine.addUndefindedNeighbor(new LineOfPuzzle(null, null, null, null, null, "Dunhill"));
                                            }
                                            if (cigarette.equalsIgnoreCase("Dunhill")
                                                    && !animal.equalsIgnoreCase("Horse")){
                                                pzlLine.addUndefindedNeighbor(new LineOfPuzzle(null, null, null, "Horse", null, null));
                                            }
                                        }
                                        validLine = true;
                                }
                            } //cigarette end
                        } //drinks end
                    } //animal end
                } //color end
            } //nations end
        } //order end

        System.out.println("After general rule set validation, remains "+
                                                puzzleTable.size() + " lines.");

        for (Iterator<LineOfPuzzle> it = puzzleTable.iterator(); it.hasNext();){
            validLine=true;

            LineOfPuzzle lineOfPuzzle = it.next();

            if (lineOfPuzzle.hasLeftNeighbor()){
                LineOfPuzzle neighbor = lineOfPuzzle.getLeftNeighbor();
                if (neighbor.getOrder()<1 || neighbor.getOrder()>5){
                    validLine=false;
                    it.remove();

                }
            }
            if (validLine && lineOfPuzzle.hasRightNeighbor()){
                LineOfPuzzle neighbor = lineOfPuzzle.getRightNeighbor();
                if (neighbor.getOrder()<1 || neighbor.getOrder()>5){
                    it.remove();
                }
            }
        }

        System.out.println("After removing out of bound neighbors, remains " +
                                                puzzleTable.size() + " lines.");

        //Setting left and right neighbors
        for (Iterator<LineOfPuzzle> it = puzzleTable.iterator(); it.hasNext();) {
            LineOfPuzzle puzzleLine = it.next();

            if (puzzleLine.hasUndefNeighbors()){
                for (Iterator<LineOfPuzzle> it1 = puzzleLine.getUndefNeighbors().iterator(); it1.hasNext();) {
                    LineOfPuzzle leftNeighbor = it1.next();
                    LineOfPuzzle rightNeighbor = leftNeighbor.clone();

                    //make it left neighbor
                    leftNeighbor.setOrder(puzzleLine.getOrder()-1);
                    if (puzzleTable.contains(leftNeighbor)){
                        if (puzzleLine.hasLeftNeighbor())
                            puzzleLine.getLeftNeighbor().merge(leftNeighbor);
                        else
                            puzzleLine.setLeftNeighbor(leftNeighbor);
                    }
                    rightNeighbor.setOrder(puzzleLine.getOrder()+1);
                    if (puzzleTable.contains(rightNeighbor)){
                        if (puzzleLine.hasRightNeighbor())
                            puzzleLine.getRightNeighbor().merge(rightNeighbor);
                        else
                            puzzleLine.setRightNeighbor(rightNeighbor);
                    }
                }
            }
        }

        int iteration=1;
        int lastSize=0;

        //Recursively validate against neighbor rules
        while (puzzleTable.size()>5 && lastSize != puzzleTable.size()) {
            lastSize = puzzleTable.size();
            puzzleTable.clearLineCountFlags();

            recursiveSearch(null, puzzleTable, -1);

            ruleSet.clear();
            // Assuming we'll get at leas one valid line each iteration, we create
            // a set of new rules with lines which have no more then one instance of same OrderId.
            for (int i = 1; i < 6; i++) {
                if (puzzleTable.getLineCountByOrderId(i)==1)
                   ruleSet.addAll(puzzleTable.getSimilarLines(new LineOfPuzzle(i, null, null, null, null, null)));
            }

            for (Iterator<LineOfPuzzle> it = puzzleTable.iterator(); it.hasNext();) {
                LineOfPuzzle puzzleLine = it.next();

                if (!ruleSet.accepts(puzzleLine))
                    it.remove();
            }
            //
            System.out.println("After " + iteration + " recursive iteration, remains "
                                                + puzzleTable.size() + " lines");
            iteration+=1;
        }

        // Print the results
        System.out.println("-------------------------------------------");
        if (puzzleTable.size()==5){
            for (Iterator<LineOfPuzzle> it = puzzleTable.iterator(); it.hasNext();) {
            LineOfPuzzle puzzleLine = it.next();
                System.out.println(puzzleLine.getWholeLine());
            }
        }else
            System.out.println("Sorry, solution not found!");
    }

    // Recursively checks the input set to ensure each line has right neighbor.
    // Neighbors can be of three type, left, right or undefined.
    // Direction: -1 left, 0 undefined, 1 right
    private static boolean recursiveSearch(LineOfPuzzle pzzlNodeLine,
                                           PuzzleSet puzzleSet, int direction){
        boolean validLeaf = false;
        boolean hasNeighbor = false;
        PuzzleSet<LineOfPuzzle> puzzleSubSet = null;

        for (Iterator<LineOfPuzzle> it = puzzleSet.iterator(); it.hasNext();) {
            LineOfPuzzle pzzlLeafLine = it.next();
            validLeaf = false;

            hasNeighbor = pzzlLeafLine.hasNeighbor(direction);

            if (hasNeighbor){
                puzzleSubSet = puzzleTable.getSimilarLines(pzzlLeafLine.getNeighbor(direction));
                if (puzzleSubSet != null){
                    if (pzzlNodeLine !=null)
                        validLeaf = puzzleSubSet.contains(pzzlNodeLine);
                    else
                        validLeaf = recursiveSearch(pzzlLeafLine, puzzleSubSet, -1*direction);
                }
                else
                    validLeaf = false;
            }

            if (!validLeaf && pzzlLeafLine.hasNeighbor(-1*direction)){
                hasNeighbor = true;
                if (hasNeighbor){
                    puzzleSubSet = puzzleTable.getSimilarLines(pzzlLeafLine.getNeighbor(-1*direction));
                    if (puzzleSubSet != null){
                        if (pzzlNodeLine !=null)
                            validLeaf = puzzleSubSet.contains(pzzlNodeLine);
                        else
                            validLeaf = recursiveSearch(pzzlLeafLine, puzzleSubSet, direction);
                    }
                    else
                        validLeaf = false;
                }
            }

            if (pzzlNodeLine != null && validLeaf)
                return validLeaf;

            if (pzzlNodeLine == null && hasNeighbor && !validLeaf){
                it.remove();
            }

            if (pzzlNodeLine == null){
                if (hasNeighbor && validLeaf){
                     puzzleSet.riseLineCountFlags(pzzlLeafLine.getOrder());
                }
                if (!hasNeighbor){
                    puzzleSet.riseLineCountFlags(pzzlLeafLine.getOrder());
                }
            }
        }
        return validLeaf;
    }
}

package org.rosettacode.zebra;

import java.util.Arrays;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.Objects;
import java.util.Set;

public class Zebra {

    private static final int[] orders = {1, 2, 3, 4, 5};
    private static final String[] nations = {"English", "Danish", "German", "Swedish", "Norwegian"};
    private static final String[] animals = {"Zebra", "Horse", "Birds", "Dog", "Cats"};
    private static final String[] drinks = {"Coffee", "Tea", "Beer", "Water", "Milk"};
    private static final String[] cigarettes = {"Pall Mall", "Blend", "Blue Master", "Prince", "Dunhill"};
    private static final String[] colors = {"Red", "Green", "White", "Blue", "Yellow"};

    static class Solver {
        private final PossibleLines puzzleTable = new PossibleLines();

        void solve() {
            PossibleLines constraints = new PossibleLines();
            constraints.add(new PossibleLine(null, "English", "Red", null, null, null));
            constraints.add(new PossibleLine(null, "Swedish", null, "Dog", null, null));
            constraints.add(new PossibleLine(null, "Danish", null, null, "Tea", null));
            constraints.add(new PossibleLine(null, null, "Green", null, "Coffee", null));
            constraints.add(new PossibleLine(null, null, null, "Birds", null, "Pall Mall"));
            constraints.add(new PossibleLine(null, null, "Yellow", null, null, "Dunhill"));
            constraints.add(new PossibleLine(3, null, null, null, "Milk", null));
            constraints.add(new PossibleLine(1, "Norwegian", null, null, null, null));
            constraints.add(new PossibleLine(null, null, null, null, "Beer", "Blue Master"));
            constraints.add(new PossibleLine(null, "German", null, null, null, "Prince"));
            constraints.add(new PossibleLine(2, null, "Blue", null, null, null));

            //Creating all possible combination of a puzzle line.
            //The maximum number of lines is 5^^6 (15625).
            //Each combination line is checked against a set of knowing facts, thus
            //only a small number of line result at the end.
            for (Integer orderId : Zebra.orders) {
                for (String nation : Zebra.nations) {
                    for (String color : Zebra.colors) {
                        for (String animal : Zebra.animals) {
                            for (String drink : Zebra.drinks) {
                                for (String cigarette : Zebra.cigarettes) {
                                    addPossibleNeighbors(constraints, orderId, nation, color, animal, drink, cigarette);
                                }
                            }
                        }
                    }
                }
            }

            System.out.println("After general rule set validation, remains " +
                    puzzleTable.size() + " lines.");

            for (Iterator<PossibleLine> it = puzzleTable.iterator(); it.hasNext(); ) {
                boolean validLine = true;

                PossibleLine possibleLine = it.next();

                if (possibleLine.leftNeighbor != null) {
                    PossibleLine neighbor = possibleLine.leftNeighbor;
                    if (neighbor.order < 1 || neighbor.order > 5) {
                        validLine = false;
                        it.remove();
                    }
                }
                if (validLine && possibleLine.rightNeighbor != null) {
                    PossibleLine neighbor = possibleLine.rightNeighbor;
                    if (neighbor.order < 1 || neighbor.order > 5) {
                        it.remove();
                    }
                }
            }

            System.out.println("After removing out of bound neighbors, remains " +
                    puzzleTable.size() + " lines.");

            //Setting left and right neighbors
            for (PossibleLine puzzleLine : puzzleTable) {
                for (PossibleLine leftNeighbor : puzzleLine.neighbors) {
                    PossibleLine rightNeighbor = leftNeighbor.copy();

                    //make it left neighbor
                    leftNeighbor.order = puzzleLine.order - 1;
                    if (puzzleTable.contains(leftNeighbor)) {
                        if (puzzleLine.leftNeighbor != null)
                            puzzleLine.leftNeighbor.merge(leftNeighbor);
                        else
                            puzzleLine.setLeftNeighbor(leftNeighbor);
                    }
                    rightNeighbor.order = puzzleLine.order + 1;
                    if (puzzleTable.contains(rightNeighbor)) {
                        if (puzzleLine.rightNeighbor != null)
                            puzzleLine.rightNeighbor.merge(rightNeighbor);
                        else
                            puzzleLine.setRightNeighbor(rightNeighbor);
                    }
                }
            }

            int iteration = 1;
            int lastSize = 0;

            //Recursively validate against neighbor rules
            while (puzzleTable.size() > 5 && lastSize != puzzleTable.size()) {
                lastSize = puzzleTable.size();
                puzzleTable.clearLineCountFlags();

                recursiveSearch(null, puzzleTable, -1);

                constraints.clear();
                // Assuming we'll get at leas one valid line each iteration, we create
                // a set of new rules with lines which have no more then one instance of same OrderId.
                for (int i = 1; i < 6; i++) {
                    if (puzzleTable.getLineCountByOrderId(i) == 1)
                        constraints.addAll(puzzleTable.getSimilarLines(new PossibleLine(i, null, null, null, null,
                                null)));
                }

                puzzleTable.removeIf(puzzleLine -> !constraints.accepts(puzzleLine));

                System.out.println("After " + iteration + " recursive iteration, remains "
                        + puzzleTable.size() + " lines");
                iteration++;
            }

            // Print the results
            System.out.println("-------------------------------------------");
            if (puzzleTable.size() == 5) {
                for (PossibleLine puzzleLine : puzzleTable) {
                    System.out.println(puzzleLine.getWholeLine());
                }
            } else
                System.out.println("Sorry, solution not found!");
        }

        private void addPossibleNeighbors(
                PossibleLines constraints, Integer orderId, String nation,
                String color, String animal, String drink, String cigarette) {
            boolean validLine = true;
            PossibleLine pzlLine = new PossibleLine(orderId,
                    nation,
                    color,
                    animal,
                    drink,
                    cigarette);
            // Checking against a set of knowing facts
            if (constraints.accepts(pzlLine)) {
                // Adding rules of neighbors
                if (cigarette.equals("Blend")
                        && (animal.equals("Cats") || drink.equals("Water")))
                    validLine = false;

                if (cigarette.equals("Dunhill")
                        && animal.equals("Horse"))
                    validLine = false;

                if (validLine) {
                    puzzleTable.add(pzlLine);

                    //set neighbors constraints
                    if (color.equals("Green")) {
                        pzlLine.setRightNeighbor(
                                new PossibleLine(null, null, "White", null, null, null));
                    }
                    if (color.equals("White")) {
                        pzlLine.setLeftNeighbor(
                                new PossibleLine(null, null, "Green", null, null, null));
                    }
                    //
                    if (animal.equals("Cats") && !cigarette.equals("Blend")) {
                        pzlLine.neighbors.add(new PossibleLine(null, null, null, null, null,
                                "Blend"));
                    }
                    if (cigarette.equals("Blend") && !animal.equals("Cats")) {
                        pzlLine.neighbors.add(new PossibleLine(null, null, null, "Cats", null
                                , null));
                    }
                    //
                    if (drink.equals("Water")
                            && !animal.equals("Cats")
                            && !cigarette.equals("Blend")) {
                        pzlLine.neighbors.add(new PossibleLine(null, null, null, null, null,
                                "Blend"));
                    }

                    if (cigarette.equals("Blend") && !drink.equals("Water")) {
                        pzlLine.neighbors.add(new PossibleLine(null, null, null, null, "Water"
                                , null));
                    }
                    //
                    if (animal.equals("Horse") && !cigarette.equals("Dunhill")) {
                        pzlLine.neighbors.add(new PossibleLine(null, null, null, null, null,
                                "Dunhill"));
                    }
                    if (cigarette.equals("Dunhill") && !animal.equals("Horse")) {
                        pzlLine.neighbors.add(new PossibleLine(null, null, null, "Horse",
                                null, null));
                    }
                }
            }
        }

        // Recursively checks the input set to ensure each line has right neighbor.
        // Neighbors can be of three type, left, right or undefined.
        // Direction: -1 left, 0 undefined, 1 right
        private boolean recursiveSearch(PossibleLine pzzlNodeLine,
                                        PossibleLines possibleLines, int direction) {
            boolean validLeaf = false;
            boolean hasNeighbor;
            PossibleLines puzzleSubSet;

            for (Iterator<PossibleLine> it = possibleLines.iterator(); it.hasNext(); ) {
                PossibleLine pzzlLeafLine = it.next();
                validLeaf = false;

                hasNeighbor = pzzlLeafLine.hasNeighbor(direction);

                if (hasNeighbor) {
                    puzzleSubSet = puzzleTable.getSimilarLines(pzzlLeafLine.getNeighbor(direction));
                    if (puzzleSubSet != null) {
                        if (pzzlNodeLine != null)
                            validLeaf = puzzleSubSet.contains(pzzlNodeLine);
                        else
                            validLeaf = recursiveSearch(pzzlLeafLine, puzzleSubSet, -1 * direction);
                    }
                }

                if (!validLeaf && pzzlLeafLine.hasNeighbor(-1 * direction)) {
                    hasNeighbor = true;
                    puzzleSubSet = puzzleTable.getSimilarLines(pzzlLeafLine.getNeighbor(-1 * direction));
                    if (puzzleSubSet != null) {
                        if (pzzlNodeLine != null)
                            validLeaf = puzzleSubSet.contains(pzzlNodeLine);
                        else
                            validLeaf = recursiveSearch(pzzlLeafLine, puzzleSubSet, direction);
                    }
                }

                if (pzzlNodeLine != null && validLeaf)
                    return true;

                if (pzzlNodeLine == null && hasNeighbor && !validLeaf) {
                    it.remove();
                }

                if (pzzlNodeLine == null) {
                    if (hasNeighbor && validLeaf) {
                        possibleLines.riseLineCountFlags(pzzlLeafLine.order);
                    }
                    if (!hasNeighbor) {
                        possibleLines.riseLineCountFlags(pzzlLeafLine.order);
                    }
                }
            }
            return validLeaf;
        }
    }

    public static void main(String[] args) {

        Solver solver = new Solver();
        solver.solve();
    }

    static class PossibleLines extends LinkedHashSet<PossibleLine> {

        private final int[] count = new int[5];

        public PossibleLine get(int index) {
            return ((PossibleLine) toArray()[index]);
        }

        public PossibleLines getSimilarLines(PossibleLine searchLine) {
            PossibleLines puzzleSubSet = new PossibleLines();
            for (PossibleLine possibleLine : this) {
                if (possibleLine.getCommonFactsCount(searchLine) == searchLine.getFactsCount())
                    puzzleSubSet.add(possibleLine);
            }
            if (puzzleSubSet.isEmpty())
                return null;

            return puzzleSubSet;
        }

        public boolean contains(PossibleLine searchLine) {
            for (PossibleLine puzzleLine : this) {
                if (puzzleLine.getCommonFactsCount(searchLine) == searchLine.getFactsCount())
                    return true;
            }
            return false;
        }

        public boolean accepts(PossibleLine searchLine) {
            int passed = 0;
            int notpassed = 0;

            for (PossibleLine puzzleSetLine : this) {
                int lineFactsCnt = puzzleSetLine.getFactsCount();
                int comnFactsCnt = puzzleSetLine.getCommonFactsCount(searchLine);

                if (lineFactsCnt != comnFactsCnt && lineFactsCnt != 0 && comnFactsCnt != 0) {
                    notpassed++;
                }

                if (lineFactsCnt == comnFactsCnt)
                    passed++;
            }
            return passed >= 0 && notpassed == 0;
        }

        public void riseLineCountFlags(int lineOrderId) {
            count[lineOrderId - 1]++;
        }

        public void clearLineCountFlags() {
            Arrays.fill(count, 0);
        }

        public int getLineCountByOrderId(int lineOrderId) {
            return count[lineOrderId - 1];
        }
    }

    static class PossibleLine {

        Integer order;
        String nation;
        String color;
        String animal;
        String drink;
        String cigarette;

        PossibleLine rightNeighbor;
        PossibleLine leftNeighbor;
        Set<PossibleLine> neighbors = new LinkedHashSet<>();

        public PossibleLine(Integer order, String nation, String color,
                            String animal, String drink, String cigarette) {
            this.animal = animal;
            this.cigarette = cigarette;
            this.color = color;
            this.drink = drink;
            this.nation = nation;
            this.order = order;
        }

        @Override
        public boolean equals(Object obj) {
            return obj instanceof PossibleLine
                    && getWholeLine().equals(((PossibleLine) obj).getWholeLine());
        }

        public int getFactsCount() {
            int facts = 0;
            facts += order != null ? 1 : 0;
            facts += nation != null ? 1 : 0;
            facts += color != null ? 1 : 0;
            facts += animal != null ? 1 : 0;
            facts += cigarette != null ? 1 : 0;
            facts += drink != null ? 1 : 0;
            return facts;
        }

        private static int common(Object a, Object b) {
            return a != null && Objects.equals(a, b) ? 1 : 0;
        }

        public int getCommonFactsCount(PossibleLine facts) {
            return common(order, facts.order)
                    + common(nation, facts.nation)
                    + common(color, facts.color)
                    + common(animal, facts.animal)
                    + common(cigarette, facts.cigarette)
                    + common(drink, facts.drink);
        }

        public void setLeftNeighbor(PossibleLine leftNeighbor) {
            this.leftNeighbor = leftNeighbor;
            this.leftNeighbor.order = order - 1;
        }

        public void setRightNeighbor(PossibleLine rightNeighbor) {
            this.rightNeighbor = rightNeighbor;
            this.rightNeighbor.order = order + 1;
        }

        public boolean hasNeighbor(int direction) {
            return getNeighbor(direction) != null;
        }

        public PossibleLine getNeighbor(int direction) {
            if (direction < 0)
                return leftNeighbor;
            else
                return rightNeighbor;
        }

        public String getWholeLine() {
            return order + " - " +
                    nation + " - " +
                    color + " - " +
                    animal + " - " +
                    drink + " - " +
                    cigarette;
        }

        @Override
        public int hashCode() {
            return Objects.hash(order, nation, color, animal, drink, cigarette);
        }

        public void merge(PossibleLine mergedLine) {
            if (order == null) order = mergedLine.order;
            if (nation == null) nation = mergedLine.nation;
            if (color == null) color = mergedLine.color;
            if (animal == null) animal = mergedLine.animal;
            if (drink == null) drink = mergedLine.drink;
            if (cigarette == null) cigarette = mergedLine.cigarette;
        }

        public PossibleLine copy() {
            PossibleLine clone = new PossibleLine(order, nation, color, animal, drink, cigarette);
            clone.leftNeighbor = leftNeighbor;
            clone.rightNeighbor = rightNeighbor;
            clone.neighbors = neighbors; // shallow copy
            return clone;
        }
    }
}

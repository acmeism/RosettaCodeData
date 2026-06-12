class CardShuffles {
    private static final Random rand = new Random()

    static <T> LinkedList<T> riffleShuffle(List<T> list, int flips) {
        LinkedList<T> newList = new LinkedList<T>()

        newList.addAll(list)

        for (int n = 0; n < flips; n++) {
            //cut the deck at the middle +/- 10%, remove the second line of the formula for perfect cutting
            int cutPoint = newList.size().intdiv(2) + (rand.nextBoolean() ? -1 : 1) * rand.nextInt((int) (newList.size() * 0.1))

            //split the deck
            List<T> left = new LinkedList<T>()
            left.addAll(newList.subList(0, cutPoint))
            List<T> right = new LinkedList<T>()
            right.addAll(newList.subList(cutPoint, newList.size()))

            newList.clear()

            while (left.size() > 0 && right.size() > 0) {
                //allow for imperfect riffling so that more than one card can come form the same side in a row
                //biased towards the side with more cards
                //remove the if and else and brackets for perfect riffling
                if (rand.nextDouble() >= ((double) left.size() / right.size()) / 2) {
                    newList.add(right.remove(0))
                } else {
                    newList.add(left.remove(0))
                }
            }

            //if either hand is out of cards then flip all of the other hand to the shuffled deck
            if (left.size() > 0) newList.addAll(left)
            if (right.size() > 0) newList.addAll(right)
        }
        return newList
    }

    static <T> LinkedList<T> overhandShuffle(List<T> list, int passes) {
        LinkedList<T> mainHand = new LinkedList<T>()

        mainHand.addAll(list)
        for (int n = 0; n < passes; n++) {
            LinkedList<T> otherHand = new LinkedList<T>()

            while (mainHand.size() > 0) {
                //cut at up to 20% of the way through the deck
                int cutSize = rand.nextInt((int) (list.size() * 0.2)) + 1

                LinkedList<T> temp = new LinkedList<T>()

                //grab the next cut up to the end of the cards left in the main hand
                for (int i = 0; i < cutSize && mainHand.size() > 0; i++) {
                    temp.add(mainHand.remove())
                }

                //add them to the cards in the other hand, sometimes to the front sometimes to the back
                if (rand.nextDouble() >= 0.1) {
                    //front most of the time
                    otherHand.addAll(0, temp)
                } else {
                    //end sometimes
                    otherHand.addAll(temp)
                }
            }

            //move the cards back to the main hand
            mainHand = otherHand
        }
        return mainHand
    }

    static void main(String[] args) {
        List<Integer> list = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)
        println(list)
        list = riffleShuffle(list, 10)
        println(list)
        println()

        list = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)
        println(list)
        list = riffleShuffle(list, 1)
        println(list)
        println()

        list = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)
        println(list)
        list = overhandShuffle(list, 10)
        println(list)
        println()

        list = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)
        println(list)
        list = overhandShuffle(list, 1)
        println(list)
        println()

        list = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)
        println(list)
        Collections.shuffle(list)
        println(list)
    }
}

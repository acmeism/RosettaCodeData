class FreeCell{
    int seed

    List<String> createDeck(){
        List<String> suits = ['♣','♦','♥','♠']
        List<String> values = ['A','2','3','4','5','6','7','8','9','10','J','Q','K']
        return [suits,values].combinations{suit,value -> "$suit$value"}
    }

    int random() {
        seed = (214013 * seed + 2531011) & Integer.MAX_VALUE
        return seed >> 16
    }

    List<String> shuffledDeck(List<String> cards) {
        List<String> deck = cards.clone()

       (deck.size() - 1..1).each{index ->
            int r = random() % (index + 1)
            deck.swap(r, index)
        }

        return deck
    }

    List<String> dealGame(int seed = 1){
        this.seed= seed
        List<String> cards = shuffledDeck(createDeck())

        (1..cards.size()).each{ number->
            print "${cards.pop()}\t"
            if(number % 8 == 0) println('')
        }

        println('\n')
    }
}

def freecell = new FreeCell()
freecell.dealGame()
freecell.dealGame(617)

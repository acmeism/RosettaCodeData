import static Man.*
import static Woman.*

Map<Woman,Man> match(Map<Man,Map<Woman,Integer>> guysGalRanking, Map<Woman,Map<Man,Integer>> galsGuyRanking) {
    Map<Woman,Man> engagedTo = new TreeMap()
    List<Man> freeGuys = (Man.values()).clone()
    while(freeGuys) {
        Man thisGuy = freeGuys[0]
        freeGuys -= thisGuy
        List<Woman> guyChoices = Woman.values().sort{ she -> - guysGalRanking[thisGuy][she] }
        for(Woman girl in guyChoices) {
            if(! engagedTo[girl]) {
                engagedTo[girl] = thisGuy
                break
            } else {
                Man thatGuy = engagedTo[girl]
                if (galsGuyRanking[girl][thisGuy] > galsGuyRanking[girl][thatGuy]) {
                    engagedTo[girl] = thisGuy
                    freeGuys << thatGuy
                    break
                }
            }
        }
    }
    engagedTo
}

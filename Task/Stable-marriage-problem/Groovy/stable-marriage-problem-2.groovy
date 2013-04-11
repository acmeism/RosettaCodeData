boolean isStable(Map<Woman,Man> matches, Map<Man,Map<Woman,Integer>> guysGalRanking, Map<Woman,Map<Man,Integer>> galsGuyRanking) {
    matches.collect{ girl, guy ->
        int guysRank = galsGuyRanking[girl][guy]
        List<Man> sheLikesBetter = Man.values().findAll{ he -> galsGuyRanking[girl][he] > guysRank }
        for(Man otherGuy : sheLikesBetter) {
            Woman otherGuyFiancee = matches.find{ pair -> pair.value == otherGuy }.key
            if(guysGalRanking[otherGuy][girl] > guysGalRanking[otherGuy][otherGuyFiancee]) {
                println """O. M. G. ... ${otherGuy} likes ${girl} better than ${otherGuyFiancee}, and ${girl} likes ${otherGuy} better than ${guy}!
                            I am TOTALLY 'shipping ${girl} and ${otherGuy} now!"""
                return false
            }
        }

        int galsRank = guysGalRanking[guy][girl]
        List<Woman> heLikesBetter = Woman.values().findAll{ she -> guysGalRanking[guy][she] > galsRank }
        for(Woman otherGal : heLikesBetter) {
            Man otherGalFiance = matches[otherGal]
            if(galsGuyRanking[otherGal][guy] > galsGuyRanking[otherGal][otherGalFiance]) {
                println """O. M. G. ... ${otherGal} likes ${guy} better than ${otherGalFiance}, and ${guy} likes ${otherGal} better than ${girl}!
                            I am TOTALLY 'shipping ${guy} and ${otherGal} now!"""
                return false
            }
        }
        true
    }.every()
}

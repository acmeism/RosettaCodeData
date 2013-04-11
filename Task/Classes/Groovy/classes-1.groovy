/** Ye olde classe declaration */
class Stuff {
    /** Heare bee anne instance variable declared */
    def guts

    /** This constuctor converts bits into Stuff */
    Stuff(injectedGuts) {
        guts = injectedGuts
    }

    /** Brethren and sistren, let us flangulate with this fine flangulating method */
    def flangulate() {
        println "This stuff is flangulating its guts: ${guts}"
    }
}

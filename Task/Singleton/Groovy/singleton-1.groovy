@Singleton
class SingletonClass {

    def invokeMe() {
        println 'invoking method of a singleton class'
    }

    static void main(def args) {
        SingletonClass.instance.invokeMe()
    }
}

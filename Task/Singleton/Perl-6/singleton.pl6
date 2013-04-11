class Singleton {
    # We create a lexical variable in the class block that holds our single instance.
    my Singleton $instance = Singleton.bless(*); # You can add initialization arguments here.
    method new {!!!} # Singleton.new dies.
    method instance { $instance; }
}

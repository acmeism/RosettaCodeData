use Term::ReadKey;

react {
    whenever key-pressed(:!echo) {
        given .fc {
            when 'q' { done }
            default { .uniname.say }
        }
    }
}

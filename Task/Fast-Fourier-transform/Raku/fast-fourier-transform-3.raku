sub fft {
    use TrigPi;
    @_ == 1 ?? @_ !!
    fft(@_[0,2...*]) «+«
    fft(@_[1,3...*]) «*« map &cisPi, (0,-2/@_...^-2)
}

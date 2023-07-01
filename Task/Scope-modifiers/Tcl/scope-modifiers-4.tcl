proc semival args {
    uplevel 1 [join $args ";"]
}

for [\,] $*SPEC.splitdir("../path/to/dir") -> @path {
    mkdir $_ unless .e given $*SPEC.catdir(@path).IO;
}

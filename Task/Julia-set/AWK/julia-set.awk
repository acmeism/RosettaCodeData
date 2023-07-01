# syntax: GAWK -f JULIA_SET.AWK [real imaginary]
BEGIN {
    c_real      = (ARGV[1] != "") ? ARGV[1] : -0.8
    c_imaginary = (ARGV[2] != "") ? ARGV[2] : 0.156
    printf("%s %s\n",c_real,c_imaginary)
    for (v=-100; v<=100; v+=10) {
      for (h=-280; h<=280; h+=10) {
        x = h / 200
        y = v / 100
        plot_char = "#"
        for (i=1; i<=50; i++) {
          z_real = x * x - y * y + c_real
          z_imaginary = x * y * 2 + c_imaginary
          if (z_real ^ 2 > 10000) {
            plot_char = " "
            break
          }
          x = z_real
          y = z_imaginary
        }
        printf("%1s",plot_char)
      }
      printf("\n")
    }
    exit(0)
}

\ args.f: print each command line argument on a separate line
: main
  argc @ 0 do i arg type cr loop ;

main bye

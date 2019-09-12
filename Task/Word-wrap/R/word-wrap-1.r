> x <- "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur. "
> cat(paste(strwrap(x=c(x, "\n"), width=80), collapse="\n"))
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus.
Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec
consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero
egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem
lacinia consectetur.
> cat(paste(strwrap(x=c(x, "\n"), width=60), collapse="\n"))
Lorem ipsum dolor sit amet, consectetur adipiscing elit.
Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas
congue ligula ac quam viverra nec consectetur ante
hendrerit. Donec et mollis dolor. Praesent et diam eget
libero egestas mattis sit amet vitae augue. Nam tincidunt
congue enim, ut porta lorem lacinia consectetur.

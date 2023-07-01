f = { |n| if(n < 2) { n } { f.(n-1) + f.(n-2) } };
(0..20).collect(f)

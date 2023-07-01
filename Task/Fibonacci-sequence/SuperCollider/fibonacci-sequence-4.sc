f = { |n| var a = [1, 1]; n.do { a = a.addFirst(a[0] + a[1]) }; a.reverse };
f.(18)

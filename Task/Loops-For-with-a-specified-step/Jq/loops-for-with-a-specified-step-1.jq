# If your version of jq does not have range/3, use this:
def range(m;n;step): range(0; ((n-m)/step) ) | m + (. * step);

range(2;9;2)

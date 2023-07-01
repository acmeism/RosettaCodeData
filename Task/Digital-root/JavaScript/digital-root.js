/// Digital root of 'x' in base 'b'.
/// @return {addpers, digrt}
function digitalRootBase(x,b) {
   if (x < b)
      return {addpers:0, digrt:x};

   var fauxroot = 0;
   while (b <= x) {
      x = (x / b) | 0;
      fauxroot += x % b;
   }

   var rootobj = digitalRootBase(fauxroot,b);
   rootobj.addpers += 1;
   return rootobj;
}

: inc-string ( addr n -- )
  over count number? not abort" invalid number"
  rot s>d d+  >string rot place ;

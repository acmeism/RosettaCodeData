def powerset:
  reduce .[] as $i ([[]];
     reduce .[] as $r (.; . + [$r + [$i]]));

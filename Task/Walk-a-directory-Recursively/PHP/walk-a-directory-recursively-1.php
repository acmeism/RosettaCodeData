function findFiles($dir = '.', $pattern = '/./'){
  $prefix = $dir . '/';
  $dir = dir($dir);
  while (false !== ($file = $dir->read())){
    if ($file === '.' || $file === '..') continue;
    $file = $prefix . $file;
    if (is_dir($file)) findFiles($file, $pattern);
    if (preg_match($pattern, $file)){
      echo $file . "\n";
    }
  }
}
findFiles('./foo', '/\.bar$/');

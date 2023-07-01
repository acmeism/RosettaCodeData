['input.txt':'output.txt', 'docs':'mydocs'].each { src, dst ->
  ['.', ''].each { dir ->
    new AntBuilder().move(file:"$dir/$src", toFile:"$dir/$dst")
  }
}

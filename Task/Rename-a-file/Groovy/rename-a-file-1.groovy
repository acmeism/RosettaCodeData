['input.txt':'output.txt', 'docs':'mydocs'].each { src, dst ->
  ['.', ''].each { dir ->
    new File("$dir/$src").renameTo(new File("$dir/$dst"))
  }
}

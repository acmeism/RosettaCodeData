function index($haystack,$needle) {
    $index = $haystack.IndexOf($needle)
    if($index -eq -1) {
        Write-Warning "$needle is absent"
    } else {
        $index
    }

}
$haystack = @("word", "phrase", "preface", "title", "house", "line", "chapter", "page", "book", "house")
index $haystack "house"
index $haystack "paragraph"

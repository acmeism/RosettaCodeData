ext←{
    ex←⎕C'.',¨⍺
    ex∨.≡(-≢¨ex)↑¨⊂⎕C⍵
}

test←{
    e←'zip' 'rar' '7z' 'gz' 'archive' 'A##' 'tar.bz2'
    f←'MyData.a##' 'MyData.tar.Gz' 'MyData.gzip' 'MyData.7z.backup'
    f,←'MyData...' 'MyData' 'MyData_v1.0.tar.bz2' 'MyData_V1.0.bz2'
    f,[1.5]e∘ext¨f
}

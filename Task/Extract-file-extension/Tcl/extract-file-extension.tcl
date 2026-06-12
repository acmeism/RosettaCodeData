proc assert {expr} {    ;# for "static" assertions that throw nice errors
    if {![uplevel 1 [list expr $expr]]} {
        set msg "{$expr}"
        catch {append msg " {[uplevel 1 [list subst -noc $expr]]}"}
        tailcall throw {ASSERT ERROR} $msg
    }
}

proc file_ext {file} {
    set res ""
    regexp -nocase {\.[a-z0-9]+$} $file res
    return $res
}

set map [namespace ensemble configure file -map]
dict set map ext ::file_ext
namespace ensemble configure file -map $map

# and a test:
foreach {file ext} {
    http://example.com/download.tar.gz      .gz
    CharacterModel.3DS                      .3DS
    .desktop                                .desktop
    document                                ""
    document.txt_backup                     ""
    /etc/pam.d/login                        ""
} {
    set res ""
    assert {[file ext $file] eq $ext}
}

local(haystack) = array('Zig', 'Zag', 'Wally', 'Ronald', 'Bush', 'Krusty', 'Charlie', 'Bush', 'Bozo')

#haystack->findindex('Bush')->first // 5
#haystack->findindex('Bush')->last // 8

protect => {^
    handle_error => {^ error_msg ^}
        fail_if(not #haystack->findindex('Washington')->first,'Washington is not in haystack.')
^}

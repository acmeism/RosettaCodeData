local(out) = ''
loop(10) => {
    #out->append(loop_count)
    loop_count == 10 ? loop_abort
    #out->append(', ')
}
#out

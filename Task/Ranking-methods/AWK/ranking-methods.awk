##
## Dense ranking in file: ranking_d.awk
##

BEGIN{ lastresult = "!"; lastrank = 0 }

function d_rank(){
    if($1==lastresult){
        print lastrank, $0
    }else{
        lastresult = $1
        print ++lastrank, $0 }
}
//{d_rank() }

##
## Fractional ranking in file: ranking_f.awk
##

BEGIN{
    last = "!"
    flen = 0 }

function f_rank(){
    item = $0
    if($1!=last){
        if(flen){
            sum = 0
            for(fl=0; fl < flen;){
                $0 = fifo[fl++]
                sum += $1 }
            mean = sum / flen
            for(fl=0; fl < flen;){
                $0 = fifo[fl++]
                $1 = ""
                printf("%3g %s\n", mean, $0) }
            flen = 0
    }}
    $0 = item
    last = $1
    fifo[flen++] = sprintf("%i %s", FNR, item)
}
//{f_rank()}

END{ if(flen){
        sum = 0
        for(fl=0; fl < flen;){
            $0 = fifo[fl++]
            sum += $1 }
        mean = sum / flen
        for(fl=0; fl < flen;){
            $0 = fifo[fl++]
            $1 = ""
            printf("%3g %s\n", mean, $0) }}}

##
## Modified competition ranking in file: ranking_mc.awk
##

BEGIN{
    lastresult = "!"
    flen = 0 }

function mc_rank(){
    if($1==lastresult){
        fifo[flen++] = $0
    }else{
        for(fl=0; fl < flen;){
            print FNR-1, fifo[fl++]}
        flen = 0
        fifo[flen++] = $0
        lastresult = $1}
}
//{mc_rank()}

END{ for(fl=0; fl < flen;){
        print FNR, fifo[fl++]} }

##
## Ordinal ranking in file: ranking_o.awk
##

function o_rank(){ print FNR, $0 }
//{o_rank() }

##
## Standard competition ranking in file: ranking_sc.awk
##

BEGIN{ lastresult = lastrank = "!" }

function sc_rank(){
    if($1==lastresult){
        print lastrank, $0
    }else{
        print FNR, $0
        lastresult = $1
        lastrank = FNR}
}
//{sc_rank()}

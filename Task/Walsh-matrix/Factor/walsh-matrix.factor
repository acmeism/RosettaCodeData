USING: accessors formatting images.processing images.testing
images.viewer kernel math math.matrices math.matrices.extras
sequences sequences.extras sorting.extras ui ui.gadgets
ui.gadgets.borders ui.gadgets.labeled ui.gadgets.packs ;
IN: walsh

CONSTANT: walsh1 { { 1 1 } { 1 -1 } }
CONSTANT: red B{ 0 255 0 }
CONSTANT: green B{ 255 0 0 }

: walsh ( n -- seq )
    1 - walsh1 tuck '[ _ kronecker-product ] times ;

: sequency ( n -- seq )
    walsh [ dup rest-slice [ = not ] 2count ] map-sort ;

: seq>bmp ( seq -- newseq )
    concat [ 1 = red green ? ] B{ } map-concat-as ;

: seq>img ( seq -- image )
    dup dimension <rgb-image> swap >>dim swap seq>bmp >>bitmap ;

: <img> ( seq -- gadget )
    dup length 256 swap / matrix-zoom seq>img <image-gadget> ;

: info ( seq -- str )
    length dup log2 swap dup "Order %d  (%d x %d)" sprintf ;

: <info-img> ( seq -- gadget )
    [ <img> ] [ info ] bi <labeled-gadget> ;

: <pile-by> ( seq quot -- gadget )
    <pile> -rot [ <info-img> add-gadget ] compose each ; inline

: <natural> ( -- gadget )
    { 2 4 5 } [ walsh ] <pile-by> "Natural ordering"
    <labeled-gadget> ;

: <sequency> ( -- gadget )
    { 2 4 5 } [ sequency ] <pile-by> "Sequency ordering"
    <labeled-gadget> ;

: <walsh> ( -- gadget )
    <shelf> <natural> { 3 0 } <border> add-gadget
    <sequency> { 3 0 } <border> add-gadget ;

MAIN: [ <walsh> "Walsh matrices" open-window ]

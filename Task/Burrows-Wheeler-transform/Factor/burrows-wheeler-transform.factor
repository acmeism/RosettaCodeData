USING: formatting io kernel math.transforms.bwt sequences ;
{
    "banana" "dogwood" "TO BE OR NOT TO BE OR WANT TO BE OR NOT?"
    "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES"
} [
    [ print ] [ bwt ] bi
    2dup "  bwt-->%3d %u\n" printf
    ibwt "  ibwt->    %u\n" printf nl
] each

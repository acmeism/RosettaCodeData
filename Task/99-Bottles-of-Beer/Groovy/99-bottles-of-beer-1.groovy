def bottles = { "${it==0 ? 'No more' : it} bottle${it==1 ? '' : 's' }" }

99.downto(1) { i ->
    print """
${bottles(i)} of beer on the wall
${bottles(i)} of beer
Take one down, pass it around
${bottles(i-1)} of beer on the wall
"""
}

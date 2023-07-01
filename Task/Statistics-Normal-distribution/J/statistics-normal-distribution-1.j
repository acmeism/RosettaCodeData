runif01=: ?@$ 0:                                           NB. random uniform number generator
rnorm01=. (2 o. 2p1 * runif01) * [: %: _2 * ^.@runif01     NB. random normal number generator (Box-Muller)

mean=: +/ % #                        NB. mean
stddev=: (<:@# %~ +/)&.:*:@(- mean)  NB. standard deviation
histogram=: <:@(#/.~)@(i.@#@[ , I.)

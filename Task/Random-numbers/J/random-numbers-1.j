urand=: ?@$ 0:
zrand=: (2 o. 2p1 * urand) * [: %: _2 * [: ^. urand

1 + 0.5 * zrand 100

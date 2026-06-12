DA =: '0123456789ABCDEF'
to_bytes =: 16 16#.(2,~2%~#)$ DA i. ]
upper =: 1&(3!:12)
xor =: 22 b.
and =: 17 b.

hmac_sha1 =: {{
sha1 =. _1&(128!:6)

b_size =. 512 % 8

pad_key =. b_size {.]

block_sized_key  =. pad_key a.&i. x
o_key_pad =. block_sized_key xor b_size $ 16b5c
i_key_pad =. block_sized_key xor b_size $ 16b36

hashed =. sha1 (i_key_pad { a.), y
a. i. sha1 (o_key_pad { a.), hashed }}

totp =: {{
h =. x hmac_sha1&:(a. {~ to_bytes&]) y
offset =. 16bf and {: h
1000000|16b7fffffff and (4$256)#. 4 {. offset |. h }}

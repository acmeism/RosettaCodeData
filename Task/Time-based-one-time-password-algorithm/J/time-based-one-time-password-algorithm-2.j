time =: '0000000000000001' NB. 64-bit timestamp in hex format
secrete =: 'AB54A98CEB1F0AD2' NB. secrete key in hex format
time totp secrete NB. 758742

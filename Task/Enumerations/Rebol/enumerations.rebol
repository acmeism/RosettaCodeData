*Protocol-type: enum [
	CHANGE_CIPHER_SPEC: 20
	ALERT:              21
	HANDSHAKE:          22
	APPLICATION:        23
] 'TLS-protocol-type
*Protocol-type/APPLICATION ;== 23
*Protocol-type/name 23     ;== 'APPLICATION
*Protocol-type/assert 23   ;== #(true)
*Protocol-type/assert 24   ;** Script error: invalid value 24 for: TLS-protocol-type

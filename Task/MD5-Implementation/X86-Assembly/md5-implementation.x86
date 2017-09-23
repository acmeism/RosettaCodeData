section .text
org 0x100
	mov	di, md5_for_display
	mov	si, test_input_1
	mov	cx, test_input_1_len
	call	compute_md5
	call	display_md5
	mov	si, test_input_2
	mov	cx, test_input_2_len
	call	compute_md5
	call	display_md5
	mov	si, test_input_3
	mov	cx, test_input_3_len
	call	compute_md5
	call	display_md5
	mov	si, test_input_4
	mov	cx, test_input_4_len
	call	compute_md5
	call	display_md5
	mov	si, test_input_5
	mov	cx, test_input_5_len
	call	compute_md5
	call	display_md5
	mov	si, test_input_6
	mov	cx, test_input_6_len
	call	compute_md5
	call	display_md5
	mov	si, test_input_7
	mov	cx, test_input_7_len
	call	compute_md5
	call	display_md5
	mov	ax, 0x4c00
	int	21h

md5_for_display times 16 db 0
HEX_CHARS db '0123456789ABCDEF'

display_md5:
	mov	ah, 9
	mov	dx, display_str_1
	int	0x21
	push	cx
	push	si
	mov	cx, 16
	mov	si, di
	xor	bx, bx
.loop:
	lodsb
	mov	bl, al
	and	bl, 0x0F
	push	bx
	mov	bl, al
	shr	bx, 4
	mov	ah, 2
	mov	dl, [HEX_CHARS + bx]
	int	0x21
	pop	bx
	mov	dl, [HEX_CHARS + bx]
	int	0x21
	dec	cx
	jnz	.loop
	mov	ah, 9
	mov	dx, display_str_2
	int	0x21
	pop	si
	pop	cx
	test	cx, cx
	jz	do_newline
	mov	ah, 2
display_string:
	lodsb
	mov	dl, al
	int	0x21
	dec	cx
	jnz	display_string
do_newline:
	mov	ah, 9
	mov	dx, display_str_3
	int	0x21
	ret;

compute_md5:
	; si --> input bytes, cx = input len, di --> 16-byte output buffer
	; assumes all in the same segment
	cld
	pusha
	push	di
	push	si
	mov	[message_len], cx

	mov	bx, cx
	shr	bx, 6
	mov	[ending_bytes_block_num], bx
	mov	[num_blocks], bx
	inc	word [num_blocks]
	shl	bx, 6
	add	si, bx
	and	cx, 0x3f
	push	cx
	mov	di, ending_bytes
	rep	movsb
	mov	al, 0x80
	stosb
	pop	cx
	sub	cx, 55
	neg	cx
	jge	add_padding
	add	cx, 64
	inc	word [num_blocks]
add_padding:
	mov	al, 0
	rep	stosb
	xor	eax, eax
	mov	ax, [message_len]
	shl	eax, 3
	mov	cx, 8
store_message_len:
	stosb
	shr	eax, 8
	dec	cx
	jnz	store_message_len
	pop	si
	mov	[md5_a], dword INIT_A
	mov	[md5_b], dword INIT_B
	mov	[md5_c], dword INIT_C
	mov	[md5_d], dword INIT_D
block_loop:
	push	cx
	cmp	cx, [ending_bytes_block_num]
	jne	backup_abcd
	; switch buffers if towards the end where padding needed
	mov	si, ending_bytes
backup_abcd:
	push	dword [md5_d]
	push	dword [md5_c]
	push	dword [md5_b]
	push	dword [md5_a]
	xor	cx, cx
	xor	eax, eax
main_loop:
	push	cx
	mov	ax, cx
	shr	ax, 4
	test	al, al
	jz	pass0
	cmp	al, 1
	je	pass1
	cmp	al, 2
	je	pass2
	; pass3
	mov	eax, [md5_c]
	mov	ebx, [md5_d]
	not	ebx
	or	ebx, [md5_b]
	xor	eax, ebx
	jmp	do_rotate

pass0:
	mov	eax, [md5_b]
	mov	ebx, eax
	and	eax, [md5_c]
	not	ebx
	and	ebx, [md5_d]
	or	eax, ebx
	jmp	do_rotate

pass1:
	mov	eax, [md5_d]
	mov	edx, eax
	and	eax, [md5_b]
	not	edx
	and	edx, [md5_c]
	or	eax, edx
	jmp	do_rotate

pass2:
	mov	eax, [md5_b]
	xor	eax, [md5_c]
	xor	eax, [md5_d]
do_rotate:
	add	eax, [md5_a]
	mov	bx, cx
	shl	bx, 1
	mov	bx, [BUFFER_INDEX_TABLE + bx]
	add	eax, [si + bx]
	mov	bx, cx
	shl	bx, 2
	add	eax, dword [TABLE_T + bx]
	mov	bx, cx
	ror	bx, 2
	shr	bl, 2
	rol	bx, 2
	mov	cl, [SHIFT_AMTS + bx]
	rol	eax, cl
	add	eax, [md5_b]
	push	eax
	push	dword [md5_b]
	push	dword [md5_c]
	push	dword [md5_d]
	pop	dword [md5_a]
	pop	dword [md5_d]
	pop	dword [md5_c]
	pop	dword [md5_b]
	pop	cx
	inc	cx
	cmp	cx, 64
	jb	main_loop
	; add to original values
	pop	eax
	add	[md5_a], eax
	pop	eax
	add	[md5_b], eax
	pop	eax
	add	[md5_c], eax
	pop	eax
	add	[md5_d], eax
	; advance pointers
	add	si, 64
	pop	cx
	inc	cx
	cmp	cx, [num_blocks]
	jne	block_loop
	mov	cx, 4
	mov	si, md5_a
	pop	di
	rep	movsd
	popa
	ret

section .data

INIT_A equ 0x67452301
INIT_B equ 0xEFCDAB89
INIT_C equ 0x98BADCFE
INIT_D equ 0x10325476

SHIFT_AMTS db 7, 12, 17, 22, 5,  9, 14, 20, 4, 11, 16, 23, 6, 10, 15, 21

TABLE_T dd 0xD76AA478, 0xE8C7B756, 0x242070DB, 0xC1BDCEEE, 0xF57C0FAF, 0x4787C62A, 0xA8304613, 0xFD469501, 0x698098D8, 0x8B44F7AF, 0xFFFF5BB1, 0x895CD7BE, 0x6B901122, 0xFD987193, 0xA679438E, 0x49B40821, 0xF61E2562, 0xC040B340, 0x265E5A51, 0xE9B6C7AA, 0xD62F105D, 0x02441453, 0xD8A1E681, 0xE7D3FBC8, 0x21E1CDE6, 0xC33707D6, 0xF4D50D87, 0x455A14ED, 0xA9E3E905, 0xFCEFA3F8, 0x676F02D9, 0x8D2A4C8A, 0xFFFA3942, 0x8771F681, 0x6D9D6122, 0xFDE5380C, 0xA4BEEA44, 0x4BDECFA9, 0xF6BB4B60, 0xBEBFBC70, 0x289B7EC6, 0xEAA127FA, 0xD4EF3085, 0x04881D05, 0xD9D4D039, 0xE6DB99E5, 0x1FA27CF8, 0xC4AC5665, 0xF4292244, 0x432AFF97, 0xAB9423A7, 0xFC93A039, 0x655B59C3, 0x8F0CCC92, 0xFFEFF47D, 0x85845DD1, 0x6FA87E4F, 0xFE2CE6E0, 0xA3014314, 0x4E0811A1, 0xF7537E82, 0xBD3AF235, 0x2AD7D2BB, 0xEB86D391
BUFFER_INDEX_TABLE dw 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 4, 24, 44, 0, 20, 40, 60, 16, 36, 56, 12, 32, 52, 8, 28, 48, 20, 32, 44, 56, 4, 16, 28, 40, 52, 0, 12, 24, 36, 48, 60, 8, 0, 28, 56, 20, 48, 12, 40, 4, 32, 60, 24, 52, 16, 44, 8, 36
ending_bytes_block_num dw 0
ending_bytes times 128 db 0
message_len dw 0
num_blocks dw 0
md5_a dd 0
md5_b dd 0
md5_c dd 0
md5_d dd 0

display_str_1 db '0x$'
display_str_2 db ' <== "$'
display_str_3 db '"', 13, 10, '$'

test_input_1:
test_input_1_len equ $ - test_input_1
test_input_2 db 'a'
test_input_2_len equ $ - test_input_2
test_input_3 db 'abc'
test_input_3_len equ $ - test_input_3
test_input_4 db 'message digest'
test_input_4_len equ $ - test_input_4
test_input_5 db 'abcdefghijklmnopqrstuvwxyz'
test_input_5_len equ $ - test_input_5
test_input_6 db 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
test_input_6_len equ $ - test_input_6
test_input_7 db '12345678901234567890123456789012345678901234567890123456789012345678901234567890'
test_input_7_len equ $ - test_input_7

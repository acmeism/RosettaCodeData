isPrime =: 1&p:
save_if_prime =: , (isPrime # _1 2&p.)@:{:
increment_tail =: _1&(>:@:{`[`]})
While =: conjunction def 'u^:(0~:v)^:_'
tacit_loop =: [: }: (increment_tail@:save_if_prime@:]While(>: #) x:)

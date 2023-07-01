Until =: conjunction def 'u^:(0 -: v)^:_'
Filter =: (#~`)(`:6)
totient =: 5&p:
totient_chain =: [: }. (, totient@{:)Until(1={:)
ptnQ =: (= ([: +/ totient_chain))&>

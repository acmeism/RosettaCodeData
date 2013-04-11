;;; ASN.1 serialization logic specialized for animal class
(defmethod serialize-to-asn-1 ((a animal))
  #| ... |#
  )

 ;;; casually introduce the method over strings too; no relation to animal
(defmethod serialize-to-asn-1 ((s string))
  #| ... #|
  )

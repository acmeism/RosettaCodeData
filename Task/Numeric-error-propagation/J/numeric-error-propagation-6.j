add=: +&num unc dist&unc
sub=: -&num unc dist&unc
mul=: *&num unc |@(*&num * dist&(unc%num))
div=: %&num unc |@(%&num * dist&(unc%num))
exp=: ^&num unc |@(^&num * dist&(unc%num))

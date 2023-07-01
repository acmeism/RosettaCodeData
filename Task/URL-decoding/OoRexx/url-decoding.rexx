/* Rexx */
  X = 0
  url. = ''
  X = X + 1; url.0 = X; url.X = 'http%3A%2F%2Ffoo%20bar%2F'
  X = X + 1; url.0 = X; url.X = 'mailto%3A%22Ivan%20Aim%22%20%3Civan%2Eaim%40email%2Ecom%3E'
  X = X + 1; url.0 = X; url.X = '%6D%61%69%6C%74%6F%3A%22%49%72%6D%61%20%55%73%65%72%22%20%3C%69%72%6D%61%2E%75%73%65%72%40%6D%61%69%6C%2E%63%6F%6D%3E'

  Do u_ = 1 to url.0
    Say url.u_
    Say DecodeURL(url.u_)
    Say
    End u_

Exit

DecodeURL: Procedure

  Parse Arg encoded
  decoded = ''
  PCT = '%'

  Do label e_ while encoded~length() > 0
    Parse Var encoded head (PCT) +1 code +2 tail
    decoded = decoded || head
    Select
      when code~strip('T')~length() = 2 & code~datatype('X') then Do
        code = code~x2c()
        decoded = decoded || code
        End
      when code~strip('T')~length() \= 0 then Do
        decoded = decoded || PCT
        tail = code || tail
        End
      otherwise
        Nop
      End
    encoded = tail
    End e_

  Return decoded

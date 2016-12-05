      ∇CAESAR[⎕]∇
    ∇
[0]   A←K CAESAR V
[1]   A←'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz'
[2]   ((,V∊A)/,V)←A[⎕IO+52|(2×K)+((A⍳,V)-⎕IO)~52]
[3]   A←V
    ∇

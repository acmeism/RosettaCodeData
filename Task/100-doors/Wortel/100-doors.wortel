; unoptimized
+^[
  @var doors []

  @for i rangei [1 100]
    @for j rangei [i 100 i]
      :!@not `j doors

  @for i rangei [1 100]
    @if `i doors
      !console.log "door {i} is open"
]
; optimized, map square over 1 to 10
!*^@sq @to 10

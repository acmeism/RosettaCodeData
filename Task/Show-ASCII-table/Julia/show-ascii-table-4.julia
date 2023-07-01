#= CONSOLE TABLES =============================================================
   rn: nrows, rh: height of rows
   cn: ncols, cw: width of columns
   T[rn,cn,rh] table data strings
   cr: rows in colum headers
   CH[cn,cr] column header strings of max cw length
   hl: lengths of row header strings
   RH[rn,rh] row header strings of max length hl
==============================================================================#

struct Table
  rn::Int; rh::Int; cn::Int; cw::Int; T::Array{String,3}
  cr::Int; CH::Array{String,2}
  hl::Int; RH::Array{String,2}
  function Table(rn,rh,cn,cw,cr,hl) # constructor
    new(rn,rh,cn,cw,fill("",(rn,cn,rh)), # arrays initialized with empty strings
        cr,fill("",(cr,cn)), hl,fill("",(rn,rh)))
  end
end
Base.iterate(T::Table,i=1) = i<=nfields(T) ? (getfield(T,i),i+1) : nothing

cpad(s::String,n::Integer) = (m=length(s))<n ? lpad(rpad(s,(n+m)>>1),n) : first(s,n)

function prt((rn,rh,cn,cw,T, cr,CH, hl,RH)::Table)
  TL,TX,TR,BH  = '╔','╤','╗','═'
  IL,IX,IR,IV,IH='╟','┼','╢','│','─'
  BL,BX,BR,BV  = '╚','╧','╝','║'

  u,v,w,d,t = BH^cw, IH^cw, " "^hl, cn-2, " "^hl
  b = w*(cn==1 ? IL*v*IR : IL*v*(IX*v)^d*IX*v*IR)*'\n' # internal separator
  for r = 1:cr
    for c = 1:cn t*=cpad(CH[r,c],cw+1) end
    t *= "\n$w"
  end

  t *= (cn==1 ? TL*u*TR : TL*u*(TX*u)^d*TX*u*TR)*'\n' # top border
  for r = 1:rn
    for p = 1:rh
      s = cpad(RH[r,p],hl)*BV
      for c = 1:cn-1
        s *= cpad(T[r,c,p],cw) * IV
      end
      t*= s * cpad(T[r,cn,p],cw) * BV *'\n'
    end
    t*=r<rn ? b : cn<2 ? w*BL*u*BR : w*BL*u*(BX*u)^d*BX*u*BR # bottom border
  end
  println("\n$t\n")
end

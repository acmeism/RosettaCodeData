temp="<name> went for a walk in the park. <he or she> found a <noun>. <name> decided to take it home."
k = substr(temp,"<")
while k
      replace   = substr(temp,k,substr(temp,">")-k + 1)
      see "replace:" + replace + " with: "
      give with
      while k
            temp  = left(temp,k-1) + with + substr(temp,k + len(replace))
            k = substr(temp,replace)
      end
      k = substr(temp,"<")
end
see temp + nl

def encrypt(key):
  . as $s
  | explode as $xs
  | (key % 26) as $offset
  | if $offset == 0 then .
    else reduce range(0; length) as $i ( {chars: []};
           $xs[$i] as $c
           | .d = $c
           | if ($c >= 65 and $c <= 90) # 'A' to 'Z'
             then .d = $c + $offset
             | if (.d > 90) then .d += -26 else . end
             else if ($c >= 97 and $c <= 122) # 'a' to 'z'
                  then .d = $c + $offset
                  | if (.d > 122)
		    then .d += -26
		    else .
		    end
		  else .
		  end
             end
           | .chars[$i] = .d )
        | .chars | implode
    end ;

def decrypt(key): encrypt(26 - key);

"Bright vixens jump; dozy fowl quack."
| .,
  (encrypt(8)
   | ., decrypt(8) )

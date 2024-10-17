# If using jaq, then see remark above regarding `inform/1`
# Convenience function for emitting progress messages:
def inform(msg):
  (msg | tostring | stderr | empty), .;

# $encrypt should be one of true (for encryption) or false (for decryption)
def Chao($encrypt; $showSteps):
  . as $text
  | length as $len
  | if any(explode[]; . > 128)
    then "Text contains non-ASCII characters." | error
    else {left: "HXUCZVAMDSLKPEFJRIGTWOBNYQ",
          right: "PTLNBQDEOYSFAVZKGJRIHWXUMC",
          eText: "",
          temp:  [range(0;26) | ""]
         }
    | reduce range(0; $len) as $i (.;
        if $showSteps then inform("\(.left)  \(.right)\n") end

        | if $encrypt
          then .index =  (.left|index($text[$i:$i+1]))
          |    .eText += .right[.index:.index+1]
          else .index =  (.right|index($text[$i:$i+1]))
          |    .eText += .left[.index:.index+1]
          end

        | if $i == $len - 1 then .
          else # permute left
              reduce range(.index; 26) as $j (.; .temp[$j-.index]    = .left[$j:$j+1])
            | reduce range(0; .index)  as $j (.; .temp[26-.index+$j] = .left[$j:$j+1])
            | .store = .temp[1]
            | reduce range(2; 14) as $j (.; .temp[$j-1] = .temp[$j])
            | .temp[13] = .store
            | .left = (.temp | join(""))

            # permute right
            | reduce range(.index; 26) as $j (.; .temp[$j-.index]    = .right[$j:$j+1])
            | reduce range(0; .index)  as $j (.; .temp[26-.index+$j] = .right[$j:$j+1])
            | .store = .temp[0]
            | reduce range(1; 26) as $j (.; .temp[$j-1] = .temp[$j])
            | .temp[25] = .store
            | .store = .temp[2]
            | reduce range(3; 14) as $j (.; .temp[$j-1] = .temp[$j])
            | .temp[13] = .store
            | .right = (.temp | join(""))
          end )
      | .eText
    end ;

# Input: plaintext
def task:
  "The original plaintext is : \(.)",
  "The left and right alphabets after each permutation during encryption are:",
   (Chao(true; true)
    | "The ciphertext is : \(.)",
      "The recovered plaintext is : \(Chao(false; false))" );

"WELLDONEISBETTERTHANWELLSAID" | task

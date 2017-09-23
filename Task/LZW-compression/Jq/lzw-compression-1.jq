# LZW compression/decompression for strings
def lzw_compress:
  def decode: [.] | implode;
  # Build the dictionary:
  256 as $dictSize
  | (reduce range(0; $dictSize) as $i ({}; .[ $i | decode ] = $i)) as $dictionary
  | reduce explode[] as $i
      ( [$dictionary, $dictSize, "", []];        # state: [dictionary, dictSize, w, result]
        .[0] as $dictionary
        | .[1] as $dictSize
        | .[2] as $w
        | ($i | decode) as $c
        | ($w + $c ) as $wc
        | if $dictionary[$wc] then .[2] = $wc
          else
              .[2] =  $c                         # w = c
            | .[3] += [$dictionary[$w]]          # result += dictionary[w]
            | .[0][$wc] = $dictSize              # Add wc to the dictionary
            | .[1] += 1                          # dictSize ++
          end
      )
      # Output the code for w unless w == "":
      | if .[2] == "" then .[3]
        else .[3] + [.[0][.[2]]]
        end
;

def lzw_decompress:
  def decode: [.] | implode;
  # Build the dictionary - an array of strings
  256 as $dictSize
  | (reduce range(0; $dictSize) as $i ([]; .[ $i ] = ($i|decode))) as $dictionary
  | (.[0]|decode) as $w
  | reduce .[1:][] as $k
    ( [ $dictionary, $dictSize, $w, $w];   # state: [dictionary, dictSize, w, result]
      .[0][$k] as $entry
      | (if $entry then $entry
        elif $k == .[1] then .[2] + .[2][0:1]
        else error("lzw_decompress: k=\($k)")
        end) as $entry
      | .[3] += $entry                     # result += entry
      | .[0][.[1]] = .[2] + $entry[0:1]    # dictionary[dictSize] = w + entry.charAt(0);
      | .[1] += 1                          # dictSize++
      | .[2] = $entry                      # w = entry
    ) | .[3]
;

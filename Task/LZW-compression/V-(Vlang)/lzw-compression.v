fn compress(uncompressed string) []int {
   mut wsg := ""
   mut result := []int{}
   mut dict_size := 256
   mut dict := map[string]int{}
   for ial in 0 .. 256 { dict[rune(ial).str()] = ial }
   for cal in uncompressed.runes() {
      wc := wsg + rune(cal).str()
      if wc in dict { wsg = wc }
      else {
         result << dict[wsg]
         dict[wc] = dict_size
         dict_size++
         wsg = rune(cal).str()
      }
   }
   if wsg != "" { result << dict[wsg] }
   return result
}

fn decompress(compressed []int) ?string {
   mut dict_size := 256
   mut dict := map[int]string{}
   for ial in 0 .. 256 { dict[ial] = rune(ial).str() }
   mut wsg := dict[compressed[0]]
   mut result := wsg
   for kal in compressed[1..] {
      entry := if kal in dict { dict[kal] }
      else if kal == dict_size { wsg + wsg[0].ascii_str() }
      else { return none }
      result += entry
      dict[dict_size] = wsg + entry[0].ascii_str()
      dict_size++
      wsg = entry
   }
   return result
}

fn main() {
   comp := compress("TOBEORNOTTOBEORTOBEORNOT")
   println(comp)
   decomp := decompress(comp) or {
      println("Failed to decompress")
      return
   }
   println(decomp)
}

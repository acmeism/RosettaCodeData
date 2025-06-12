import scala.collection.mutable.ListBuffer
import scala.collection.immutable.Vector // Using Vector for the bad character table outer structure

/**
 * An implementation of the Boyer-Moore string search algorithm in Scala.
 * It finds all occurrences of a pattern in a text, performing a case-sensitive search on ASCII characters.
 * (Note: The original Java comment mentioned case-insensitive, but the code was case-sensitive ASCII).
 *
 * For a full description of the algorithm visit:
 * https://en.wikipedia.org/wiki/Boyer%E2%80%93Moore_string-search_algorithm
 */
object BoyerMooreStringSearch {

  /* The range of ASCII characters is 0..255, both inclusive. */
  private final val ALPHABET_SIZE = 256

  def main(args: Array[String]): Unit = {
    val texts = List(
      "GCTAGCTCTACGAGTCTA",
      "GGCTATAATGCGTA",
      "there would have been a time for such a word",
      "needle need noodle needle",
      "DKnuthusesandshowsanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguagestoillustrate",
      "Farms grew an acre of alfalfa on the dairy's behalf, with bales of that alfalfa exchanged for milk."
    )

    val patterns = List("TCTA", "TAATAAA", "word", "needle", "put", "and", "alfalfa")

    texts.zipWithIndex.foreach { case (text, i) =>
      println(s"text${i + 1} = $text")
    }
    println()

    patterns.zipWithIndex.foreach { case (pattern, i) =>
      // Replicate the original Java logic for selecting the text index 'j'
      val j = if (i < 5) i else i - 1
      if (j >= 0 && j < texts.length) { // Ensure j is a valid index
        val textToSearch = texts(j)
        val matches = stringSearch(textToSearch, pattern)
        // Use mkString for cleaner list output
        println(s"""Found "$pattern" in 'text${j + 1}' at indexes [${matches.mkString(", ")}]""")
      } else {
         println(s"Skipping pattern '$pattern' - calculated text index $j is out of bounds.")
      }
    }
  }

  /**
   * Return a list of indexes at which the given pattern matches the given text.
   */
  private def stringSearch(aText: String, aPattern: String): List[Int] = {
    if (aPattern.isEmpty || aText.isEmpty || aText.length < aPattern.length) {
      return List.empty[Int] // Use Scala's immutable empty list
    }

    val matches = ListBuffer[Int]() // Use mutable ListBuffer for efficient appending

    // Preprocessing
    val R = badCharacterTable(aPattern) // Returns Vector[Vector[Int]]
    val L = goodSuffixTable(aPattern)   // Returns Array[Int]
    val F = fullShiftTable(aPattern)    // Returns Array[Int]

    val m = aPattern.length
    val n = aText.length

    var k = m - 1 // Represents the alignment of the end of aPattern relative to aText
    var previousK = -1 // Represents the above alignment in the previous phase (for Galil's rule)

    while (k < n) {
      var i = m - 1 // Index of the character to compare in aPattern (from right to left)
      var h = k     // Index of the character to compare in aText (aligned with i)

      // Character comparison loop
      // Galil's rule optimization: h > previousK avoids re-comparing known matched prefix
      while (i >= 0 && h > previousK && aPattern(i) == aText(h)) {
        i -= 1
        h -= 1
      }

      if (i == -1 || h == previousK) { // Match has been found OR comparison skipped by Galil's rule up to a previously matched prefix
        matches.append(k - m + 1) // Add start index of match
        // Calculate shift based on the full shift table F for the next potential match
        // F[1] represents the border length of P[1..m-1]
        val shift = if (m > 1) m - F(1) else 1
        k += shift
        // previousK is NOT reset here per original logic; it's related to shifts during *mismatches*
      } else { // Mismatch occurred at aText(h) and aPattern(i)
        // Bad Character Rule shift:
        // R(char code)(index in pattern + 1) gives the index of the previous occurrence
        // of the mismatched text character `aText(h)` in the pattern `aPattern`
        // at or before index `i`. The +1 adjusts for the table structure.
        val charShift = i - R(alphabetIndex(aText(h)))(i + 1)

        // Good Suffix Rule shift:
        val suffixShift =
          if (i + 1 == m) { // Mismatch occurred on the first character comparison (rightmost)
            1
          } else {
            // L(i + 1) stores the starting index of the rightmost occurrence of
            // the matched suffix P[i+1 .. m-1] in P that is not a suffix of P.
            // F(i + 1) stores the length of the longest suffix of P[i+1..m-1] that is also a prefix of P.
            if (L(i + 1) == -1) { // Matched suffix P[i+1..m-1] does not appear elsewhere in P preceded by a different char
              // Shift based on the longest suffix of P[i+1..m-1] that is also a prefix of P (using F table)
               m - F(i + 1)
            } else { // Matched suffix P[i+1..m-1] appears starting at index L(i+1)
              // Shift to align this previous occurrence with the text
              m - 1 - L(i + 1)
            }
          }

        // Choose the maximum shift from the two rules
        val shift = math.max(charShift, suffixShift)

        // Galil's rule: If the shift skips over the potential match area entirely,
        // remember the current alignment `k` to optimize the next comparison loop.
        if (shift >= i + 1) {
           previousK = k
        }
        // Per original Java code: If Galil's rule does not apply (shift < i + 1), previousK is not modified here.

        k += shift // Apply the calculated shift
      }
    } // end while

    matches.toList // Convert mutable buffer to immutable list for the result
  }

  /**
   * Create the shift table, F, for the given pattern P, which is an array such that
   * F[i] is the length of the longest suffix of P[i..m-1] which is also a prefix of P.
   *
   * Use case: If a mismatch occurs at character index i - 1 in the pattern, and the
   * good suffix rule L[i] indicates no earlier occurrence, the shift is P.length() - F[i].
   */
  private def fullShiftTable(aPattern: String): Array[Int] = {
    val m = aPattern.length
    val F = new Array[Int](m) // Initialize with 0s
    val Z = fundamentalPreprocess(aPattern) // Z[i] = length of longest substring starting at i that is prefix of pattern
    val Z_reversed = Z.reverse // Reverse Z array

    var longest = 0
    // Iterate through the reversed Z array to build F from right-to-left effectively
    for (i <- 0 until Z_reversed.length) {
       val zv = Z_reversed(i)
       // If Z value equals its length from the end, it's a suffix that's also a prefix
       if (zv == i + 1) {
         longest = math.max(zv, longest)
       }
       // Map the reversed index 'i' back to the original index for F
       val originalIndex = m - 1 - i
       if (originalIndex >= 0 && originalIndex < m) { // Bounds check
         F(originalIndex) = longest
       }
    }
    F
  }

 /**
  * Create the good suffix table, L', for the given pattern P (often denoted L' or L[i] in literature).
  * L'[i] = k, is the largest index k < m such that P[i..m-1] is a suffix of P[0..k-1]
  * and the character preceding the suffix P[k - (m-i) .. k-1] is different from P[i-1].
  * If no such k exists, L'[i] = -1.
  *
  * Use case: If a mismatch occurs at index i - 1, shift by m - 1 - L'[i].
  * This implementation calculates a related table L where L[i] stores j such that
  * P[i..m-1] matches P[j-(m-i)..j].
  */
  private def goodSuffixTable(aPattern: String): Array[Int] = {
    val m = aPattern.length
    // Initialize L with -1. Size is m.
    val L = Array.fill(m)(-1)
    val reversedPattern = aPattern.reverse
    // N[j] = length of longest substring starting at j that is prefix of reversedPattern
    // This corresponds to matching suffixes of the original pattern.
    val N = fundamentalPreprocess(reversedPattern)
    // Reverse N to align indices with the original pattern's perspective
    val N_reversed = N.reverse

    // N_reversed[j] = length of longest suffix of P ending at j that is also suffix of P
    for (j <- 0 until m - 1) {
        // i = position in P where the suffix match starts (from the right end)
        val suffixLen = N_reversed(j)
        val i = m - suffixLen
        // L[i] should store the end position 'j' of the matching internal suffix.
        // Condition i != m means the suffix is not the whole pattern itself.
        if (i != m) {
            if (i >= 0 && i < m) { // Bounds check for L index
               L(i) = j
            }
        }
    }
    L
  }

 /**
  * Create the bad character table, R.
  * R(c)(i) stores the index of the rightmost occurrence of character `c`
  * in the pattern `P` at or before index `i-1`. If `c` does not occur
  * before index `i`, it stores -1.
  * The table is represented as Vector[Vector[Int]], indexed by char code, then pattern index + 1.
  */
  private def badCharacterTable(aPattern: String): Vector[Vector[Int]] = {
    if (aPattern.isEmpty) {
      return Vector.empty // Return empty structure if pattern is empty
    }
    val m = aPattern.length

    // Use ListBuffer internally for efficient construction, then convert to Vector
    val R_buffers = Array.fill(ALPHABET_SIZE)(ListBuffer(-1)) // Initialize inner lists with -1
    // 'alpha' tracks the most recent index seen for each character
    val alpha = Array.fill(ALPHABET_SIZE)(-1)

    for (i <- 0 until m) {
      val charIndex = alphabetIndex(aPattern(i))
      alpha(charIndex) = i // Update last seen position for this character
      // For each character in the alphabet, append its *current* last seen position
      // This builds the table column by column (for each pattern index i)
      for (j <- 0 until ALPHABET_SIZE) {
        R_buffers(j).append(alpha(j))
      }
    }
    // Convert the mutable buffers to immutable Vectors
    R_buffers.map(_.toVector).toVector
  }

  /**
   * Create the fundamental preprocess array, Z, for the given text (or pattern).
   * Z[i] is the length of the longest substring starting at index i
   * which is also a prefix of the text. Z[0] is defined as the text length.
   * This is used in calculating the Good Suffix and Full Shift tables.
   */
  private def fundamentalPreprocess(aText: String): Array[Int] = {
    val n = aText.length
    if (n == 0) return Array.empty[Int]
    if (n == 1) return Array(1)

    val Z = new Array[Int](n)
    Z(0) = n
    Z(1) = matchLength(aText, 0, 1) // Calculate Z[1] explicitly

    // Optimization for early part based on Z[1]
    // Use Scala range 'until' for exclusive upper bound
    var initial_z1_limit = math.min(Z(1) + 1, n) // Limit loop correctly
    for (i <- 2 until initial_z1_limit) {
       Z(i) = Z(1) - i + 1
    }

    // Define the left and right limits of the current Z-box [left, right]
    var left = 0
    var right = 0
    // If Z(1) > 0, the initial Z-box is [1, Z(1)] ? No, Z-box related to previous calculations.
    // Need to initialize left/right correctly based on Z[1] usage or start fresh.
    // Let's restart Z-box calculation from where the optimization loop left off.

    val loopStart = if (Z(1) > 0) math.min(2 + Z(1), n) else 2 // Start after initial Z[1] optimization range
    // Correct initialization of Z-box should be based on the *last* Z calculation that extended right boundary.
    // Resetting left/right and letting the loop find the first Z-box might be simpler/safer.
    left = 0
    right = 0

    // Calculate remaining Z values using Z-box optimization
    for (i <- loopStart until n) {
      if (i <= right) { // i falls within existing Z-box [left, right]
        val k = i - left // Corresponding index within the prefix
        val b = Z(k)     // Length of match starting at k
        val a = right - i + 1 // Remaining length within the Z-box from i

        if (b < a) { // Match Z[k] is strictly contained within the Z-box suffix
          Z(i) = b
        } else { // Match Z[k] extends to or past the end of the Z-box
                 // Need explicit comparison beyond the Z-box
          // Match length from text[a..] against text[right+1..]
          val matchLen = matchLength(aText, a, right + 1)
          Z(i) = a + matchLen
          left = i // Start a new Z-box
          right = i + Z(i) - 1
        }
      } else { // i is outside the current Z-box
        Z(i) = matchLength(aText, 0, i) // Calculate Z[i] by explicit comparison with prefix
        if (Z(i) > 0) { // If a match is found, start a new Z-box
          left = i
          right = i + Z(i) - 1
        }
         // else: Z[i] is 0, no Z-box formed, left/right remain unchanged
      }
    }
    Z
  }

  /**
   * Return the length of the match of the two substrings of the given text
   * beginning at each of the given indexes.
   */
  private def matchLength(aText: String, aIndexOne: Int, aIndexTwo: Int): Int = {
    if (aIndexOne < 0 || aIndexTwo < 0 || aIndexOne >= aText.length || aIndexTwo >= aText.length) {
        return 0 // Added boundary checks
    }
    if (aIndexOne == aIndexTwo) {
      // Match length from index to end of string
      return aText.length - aIndexOne
    }

    var matchCount = 0
    var idx1 = aIndexOne
    var idx2 = aIndexTwo
    // Use Scala's string indexing aText(idx)
    while (idx1 < aText.length && idx2 < aText.length && aText(idx1) == aText(idx2)) {
      matchCount += 1
      idx1 += 1
      idx2 += 1
    }
    matchCount
  }

  /**
   * Return the ASCII index (0-255) of the given character.
   * Throws IllegalArgumentException if the character code is outside the 0-255 range.
   */
  private def alphabetIndex(aChar: Char): Int = {
    val result = aChar.toInt
    // Ensure character fits within the expected ASCII range for the table size
    if (result < 0 || result >= ALPHABET_SIZE) {
      // Consider if non-ASCII should be handled differently or error is correct.
      // Sticking to original logic which assumes ASCII range 0-255.
      throw new IllegalArgumentException(s"Character '$aChar' (code $result) is outside the expected ASCII range [0, ${ALPHABET_SIZE - 1}]")
    }
    result
  }
}

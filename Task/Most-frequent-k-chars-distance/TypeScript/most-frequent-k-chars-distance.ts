//returns an object of counts keyed by character
const kCounts = (str: string): Record<string, number> => {
  const counts: Record<string, number> = {};
  for (let char of str) {
    counts[char] = counts[char] ? counts[char] + 1 : 1;
  }
  return counts;
};

//returns an array of length k containing the characters with the highest counts
const frequentK = ( counts: Record<string, number>, k: number ): string[] => {
  //note that this is written for clarity rather than speed,
  //as it sorts all of the counts when only the top k are needed
  return Object.keys(counts)
    .sort((a, b) => counts[b] - counts[a])
    .slice(0, k);
};

//returns a hashed string of the most frequent k characters and their frequencies
const mostFreqKHashing = (str: string, k: number): string => {
  const counts = kCounts(str);
  return frequentK(counts, k)
    .map(char => char + counts[char])
    .join("");
};

//numeric score of similarity based on the sum of counts of characters appearing in the top k of both strings
const mostFreqKSimilarity = ( str1: string, str2: string, k: number ): number => {
  const counts1 = kCounts(str1);
  const counts2 = kCounts(str2);
  const freq1 = frequentK(counts1, k);
  const freq2 = frequentK(counts2, k);
  let similarity = 0;
  for (let char of freq1) {
    //only considers a character if it is in the top k of both strings
    if (freq2.includes(char)) {
      //the examples on this page are inconsistent in whether the similarity
      //should be the sum of the two counts or only the shared count (the minimum of the two)
      //this code uses the sum
      similarity += counts1[char] + counts2[char];
    }
  }
  return similarity;
};

//subtracts the similarity score from the maxDifference
const mostFreqKSDF = ( str1: string, str2: string, k: number, maxDistance: number ): number => {
  return maxDistance - mostFreqKSimilarity(str1, str2, k);
};

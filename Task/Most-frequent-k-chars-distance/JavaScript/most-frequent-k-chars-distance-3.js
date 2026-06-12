const str1 = "LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV";
const str2 = "EWIWGGFSVDKATLNRFFAFHFILPFTMVALAGVHLTFLHETGSNNPLGLTSDSDKIPFHPYYTIKDFLG";
const K = 2;
const maxDistance = 100;
console.log(mostFreqKHashing(str1, K));
console.log(mostFreqKHashing(str2, K));
console.log(mostFreqKSDF(str1, str2, K, maxDistance));

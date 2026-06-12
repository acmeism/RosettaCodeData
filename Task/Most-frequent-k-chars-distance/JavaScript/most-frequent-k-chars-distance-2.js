test('hash of "LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV" is "L9T8"', () => {
  expect(mostFreqKHashing(str1, 2)).toBe("L9T8");
});

test('hash of "EWIWGGFSVDKATLNRFFAFHFILPFTMVALAGVHLTFLHETGSNNPLGLTSDSDKIPFHPYYTIKDFLG" is "F9L8"', () => {
  expect(mostFreqKHashing(str2, 2)).toBe("F9L8");
});

test("SDF of strings 1 and 2 with k=2 and max=100 is 83", () => {
  expect(mostFreqKSDF(str1, str2, 2, 100)).toBe(83);
});

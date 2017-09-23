def treatmentGroup: [85, 88, 75, 66, 25, 29, 83, 39, 97];
def controlGroup: [68, 41, 10, 49, 16, 65, 32, 92, 28, 98];

permutationTest(treatmentGroup; controlGroup) as $under
| "% under=\($under)", "% over=\(100 - $under)"

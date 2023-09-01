import std.stdio;

const int[10][10] powerTable = [
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 2, 4, 8, 16, 32, 64, 128, 256, 512],
    [1, 3, 9, 27, 81, 243, 729, 2_187, 6_561, 19_683],
    [1, 4, 16, 64, 256, 1_024, 4_096, 16_384, 65_536, 262_144],
    [1, 5, 25, 125, 625, 3125, 15_625, 78_125, 390_625, 1_953_125],
    [1, 6, 36, 216, 1_296, 7_776, 46_656, 279_936, 1_679_616, 10_077_696],
    [1, 7, 49, 343, 2_401, 16_807, 117_649, 823_543, 57_64_801, 40_353_607],
    [1, 8, 64, 512, 4_096, 32_768, 262_144, 2_097_152, 16_777_216, 134_217_728],
    [1, 9, 81, 729, 6_561, 59_049, 531_441, 4_782_969, 43_046_721, 387_420_489]
];

void digitsPowerSum(ref int Number, ref int DigitCount, int Level, int Sum) {
    if (Level == 0) {
        for (int Digits = 0; Digits <= 9; ++Digits) {
            if (((Sum + powerTable[Digits][DigitCount]) == Number) && (Number >= 100)) {
                writefln("%s: %s", DigitCount, Number);
            }

            ++Number;
			
            switch (Number) {
                case 10:
                case 100:
                case 1_000:
                case 10_000:
                case 100_000:
                case 1_000_000:
                case 10_000_000:
                case 100_000_000:
                    ++DigitCount;
                    break;
				default:
					break;
            }
        }
    }
    else {
        for (int Digits = 0; Digits <= 9; ++Digits) {
            digitsPowerSum(Number, DigitCount, Level - 1, Sum + powerTable[Digits][DigitCount]);
        }
    }
}

void main() {
    int Number = 0;
    int DigitCount = 1;
	//
	digitsPowerSum(Number, DigitCount, 9-1, 0);
}

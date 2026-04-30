#include <fcntl.h>
#include <io.h>
#include <stdio.h>

const wchar_t* can[10] = {L"庚", L"辛", L"壬", L"癸", L"甲", L"乙", L"丙", L"丁", L"戊", L"己"};
const wchar_t* chi[12] = {L"申", L"酉", L"戌", L"亥", L"子", L"丑", L"寅", L"卯", L"辰", L"巳", L"午", L"未"};
const wchar_t* canPY[10] = {L"gēng", L"xīn", L"rén", L"guǐ", L"jiǎ", L"yǐ", L"bǐng", L"dīng", L"wù", L"jǐ"};
const wchar_t* chiPY[12] = {L"shēn", L"yǒu", L"xū", L"hài", L"zǐ", L"chǒu", L"yín", L"mǎo", L"chén", L"sì", L"wǔ", L"wèi"};

int wmain(int argc, wchar_t* argv[]) {
    unsigned uYear = 0;
    if (argc > 1) uYear = (unsigned)_wtoi(argv[1]);
    else scanf("%u", &uYear);
    if (!uYear) return 0;
    _setmode(_fileno(stdout), _O_U16TEXT);
    unsigned ucan=uYear%10, uchi=uYear%12, uciclo=((uYear + 56) % 60) + 1;
    wprintf(L"%s%s (%s-%s) (%u/60)\n", can[ucan], chi[uchi], canPY[ucan], chiPY[uchi], uciclo);
    return 0;
}

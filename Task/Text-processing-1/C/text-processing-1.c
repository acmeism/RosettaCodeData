#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int badHrs, maxBadHrs;

static double hrsTot = 0.0;
static int rdgsTot = 0;
char bhEndDate[40];

int mungeLine( char *line, int lno, FILE *fout )
{
    char date[40], *tkn;
    int   dHrs, flag, hrs2, hrs;
    double hrsSum;
    int   hrsCnt = 0;
    double avg;

    tkn = strtok(line, ".");
    if (tkn) {
        int n = sscanf(tkn, "%s %d", &date, &hrs2);
        if (n<2) {
            printf("badly formated line - %d %s\n", lno, tkn);
            return 0;
        }
        hrsSum = 0.0;
        while( tkn= strtok(NULL, ".")) {
            n = sscanf(tkn,"%d %d %d", &dHrs, &flag, &hrs);
            if (n>=2) {
                if (flag > 0) {
                    hrsSum += 1.0*hrs2 + .001*dHrs;
                    hrsCnt += 1;
                    if (maxBadHrs < badHrs) {
                        maxBadHrs = badHrs;
                        strcpy(bhEndDate, date);
                    }
                    badHrs = 0;
                }
                else {
                    badHrs += 1;
                }
                hrs2 = hrs;
            }
            else {
                printf("bad file syntax line %d: %s\n",lno, tkn);
            }
        }
        avg = (hrsCnt > 0)? hrsSum/hrsCnt : 0.0;
        fprintf(fout, "%s  Reject: %2d  Accept: %2d  Average: %7.3f\n",
                date, 24-hrsCnt, hrsCnt, hrsSum/hrsCnt);
        hrsTot += hrsSum;
        rdgsTot += hrsCnt;
    }
    return 1;
}

int main()
{
    FILE *infile, *outfile;
    int lineNo = 0;
    char line[512];
    const char *ifilename = "readings.txt";
    outfile = fopen("V0.txt", "w");

    infile = fopen(ifilename, "rb");
    if (!infile) {
        printf("Can't open %s\n", ifilename);
        exit(1);
    }
    while (NULL != fgets(line, 512, infile)) {
        lineNo += 1;
        if (0 == mungeLine(line, lineNo, outfile))
            printf("Bad line at %d",lineNo);
    }
    fclose(infile);

    fprintf(outfile, "File:     %s\n", ifilename);
    fprintf(outfile, "Total:    %.3f\n", hrsTot);
    fprintf(outfile, "Readings: %d\n", rdgsTot);
    fprintf(outfile, "Average:  %.3f\n", hrsTot/rdgsTot);
    fprintf(outfile, "\nMaximum number of consecutive bad readings is %d\n", maxBadHrs);
    fprintf(outfile, "Ends on date %s\n", bhEndDate);
    fclose(outfile);
    return 0;
}

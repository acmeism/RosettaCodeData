int i = 0;
tryAgain:
try {
    i++;
    if (i < 10) goto tryAgain;
}
catch {
    goto tryAgain;
}
finally {
    //goto end; //Error
}

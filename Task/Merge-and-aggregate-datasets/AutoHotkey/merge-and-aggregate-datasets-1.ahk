Merge_and_aggregate(patients, visits){
    ID := [], LAST_VISIT := [], SCORE_SUM := [], VISIT := []
    for i, line in StrSplit(patients, "`n", "`r"){
        if (i=1)
            continue
        x := StrSplit(line, ",")
        ID[x.1] := x.2
    }

    for i, line in StrSplit(visits, "`n", "`r"){
        if (i=1)
            continue
        x := StrSplit(line, ",")
        LAST_VISIT[x.1] := x.2 > LAST_VISIT[x.1] ? x.2 : LAST_VISIT[x.1]
        SCORE_SUM[x.1] := (SCORE_SUM[x.1] ? SCORE_SUM[x.1] : 0) + (x.3 ? x.3 : 0)
        if x.3
            VISIT[x.1] := (VISIT[x.1] ? VISIT[x.1] : 0) + 1
    }

    output := "PATIENT_ID`tLASTNAME`tLAST_VISIT`tSCORE_SUM`tSCORE_AVG`n"
    for id, name in ID
        output .= ID "`t" name "`t" LAST_VISIT[id] "`t" SCORE_SUM[id] "`t" SCORE_SUM[id]/VISIT[id] "`n"
    return output
}

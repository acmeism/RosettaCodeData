bash$ awk '{rec++;ok=1; for(i=0;i<24;i++){if($(2*i+3)<1){ok=0}}; recordok += ok} END {print "Total records",rec,"OK records", recordok, "or", recordok/rec*100,"%"}'  readings.txt
Total records 5471 OK records 5017 or 91.7017 %
bash$

set table "nGeTask2.pgf-plot.table"; set format "%.5f"
set format "%.7e";; f(x) = (a * x**2) + (b * x); a = 20; b = 1; fit f(x) 'calcRVsPosMagInd.tsv' u 1:2 via a,b; plot [x=0:220] f(x); set print ``task2.out''; print a,b; 

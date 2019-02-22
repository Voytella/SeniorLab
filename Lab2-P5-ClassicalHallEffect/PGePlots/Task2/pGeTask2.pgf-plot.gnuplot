set table "pGeTask2.pgf-plot.table"; set format "%.5f"
set format "%.7e";; f(x) = (a * x**2) + (b * x); a = 0.001; b = 0.01; fit f(x) 'xVy.dat' u 1:2 via a,b; plot [x=0:220] f(x); set print ``task2.out''; print a,b; 

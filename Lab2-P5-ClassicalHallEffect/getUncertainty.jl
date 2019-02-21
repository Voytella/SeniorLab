# provides propagated error
# PARAMETERS:
## command line: uncertainty of data
## STDIN: data (no new lines)

# ----------BEGIN PACKAGES----------

# pretty printing
#Pkg.add("Printf")
using Printf

# error propagation support
#Pkg.add("Measurements")
using Measurements

# -----------END PACKAGES-----------

# ----------BEGIN GET DATA----------

# get STDIN
str = readlines()

# get command line argument
uncertainty = parse(Float64, ARGS[1])

# convert the data from STDIN
data = map(x -> parse(Float64, x), split(str[1]))

# generate data/uncertainty pairs
vals = map(x -> x ± uncertainty, data)

# -----------END GET DATA-----------

# ----------BEGIN DATA PROCESSING FUNCTIONS----------

# inverse of data point
inverse(x) = 1 / x

# natural log of inverse of data point
lnInverse(x) = log(1 / x)

# \( r_0 \) for a calculated resistance
r0 = 4.67 

#calculated resistance
calcRes(rMea) = (rMea - r0) / r0

# -----------END DATA PROCESSING FUNCTIONS-----------

# ----------BEGIN UNCERTAINTIES----------

# propagate the uncertainty
uncertFunc(func, dataPt) = @uncertain (func)(dataPt)

# get the uncertainties
uncertainties(func) = map(y -> Measurements.uncertainty(y), 
                    map(x -> uncertFunc(func, x), vals))

# get the values
values(func) = map(y -> Measurements.value(y),
             map(x -> uncertFunc(func, x), vals))

# -----------END UNCERTAINTIES-----------

# print the uncertainties
for pt in uncertainties(inverse)
    @printf("%.4e\n", pt)
end

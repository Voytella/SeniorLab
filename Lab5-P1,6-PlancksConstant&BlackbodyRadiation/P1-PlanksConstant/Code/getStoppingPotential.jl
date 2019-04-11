# ----------BEGIN PACKAGES----------

# read data file
using CSV

# data structure
using DataFrames

# linear regression
using GLM

# -----------END PACKAGES-----------

# ----------BEGIN INPUT DATA----------

# get path of file
filepath = ARGS[1]
#filepath = newARGS[1]

# throw data into DataFrame
dataRaw = CSV.read(filepath, delim=' ') |> DataFrame

# -----------END INPUT DATA-----------

# ----------BEGIN LINEAR REGRESSION----------

# assume Potential: "V", Current: "I"
linReg = lm(@formula(V ~ I), dataRaw)

# -----------END LINEAR REGRESSION-----------

# display linear regression
print(linReg)

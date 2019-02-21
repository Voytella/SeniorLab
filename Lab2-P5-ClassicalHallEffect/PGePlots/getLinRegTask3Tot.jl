# get the linear regression of the data and its error

# get data from file
#Pkg.add("CSV")
using CSV

# organize data from file
#Pkg.add("DataFrames")
using DataFrames

# linear regression
#Pkg.add("GLM")
using GLM

# get the name of the data file
filename = ARGS[1]

# get the data
data = CSV.read(filename, delim=' ') |> DataFrame

# display linear regression information
print(lm(@formula(Y ~ X), data))

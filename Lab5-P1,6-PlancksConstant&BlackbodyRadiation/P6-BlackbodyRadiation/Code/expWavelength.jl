# ----------BEGIN PACKAGES----------

# read CSVs
using CSV

# data structure for input data
using DataFrames

# use derivatives
using Calculus

# pretty display
using Printf

# -----------END PACKAGES-----------

# ----------BEGIN INPUT DATA----------

# get the file path from the command line
#filepath = ARGS[1]
filepath = newARGS[1]

# throw the data from the CSV into a DataFrame
dataRaw = CSV.File(filepath) |> DataFrame

# put combine two lists (of same size) into a list of pairs
getListOfPairs(l1, l2) = [ (l1[ii], l2[ii]) for ii in 1:length(l1) ]

# get the angles in degrees
angVals = dataRaw[:Angle]

# get value-uncertainty pairs for angles
angs = getListOfPairs(angVals, fill(1.0, (1,length(angVals))))

# -----------END INPUT DATA-----------

# ----------BEGIN ERROR PROPAGATION----------

# get the bit of error for a variable into a 1-variable function
sqDer1Var(func, val, err) = (derivative(func, val)* err) ^ 2

# the propagated uncertainty of a particular value with 1-var function
propUncert1Var(func, valErrs) = sqrt(sum([ sqDer1Var(func, valErr[1], valErr[2]) 
                                       for valErr in valErrs ])) 

# -----------END ERROR PROPAGATION-----------

# ----------BEGIN WAVELENGTH FUNCTIONS----------

# index of refraction of prism
indRef(ang) = sqrt(((((2 * sin(ang)) / sqrt(3)) + (1/2)) ^ 2) + (3/4))

# wavelength of light with constants A=13900 and B=1.689
wl(indRef) = sqrt(13900 / (indRef - 1.689))

# -----------END WAVELENGTH FUNCTIONS-----------

# ----------BEGIN CALCULATE WAVELENGTH----------

# make the value-uncertainty pairs for wavelength, given the angles
wls = getListOfPairs(map(indRef, map(x -> x[1], angs)), 
                     propUncert1Var(indRef, angs))

# -----------END CALCULATE WAVELENGTH-----------

# display wavelengths
for wl in wls
    @printf("%.2e %.2e\n", wl[1], wl[2])
end

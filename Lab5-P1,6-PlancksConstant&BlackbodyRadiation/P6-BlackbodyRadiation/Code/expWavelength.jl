# Read the data file and calculate the peak wavelength.

# ----------BEGIN CONSTANTS----------

# error in angle
angErr = 1.0

# -----------END CONSTANTS-----------

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
filepath = ARGS[1]
#filepath = newARGS[1]

# throw the data from the CSV into a DataFrame
dataRaw = CSV.File(filepath) |> DataFrame

# put combine two lists (of same size) into a list of pairs
getListOfPairs(l1, l2) = [ (l1[ii], l2[ii]) for ii in 1:length(l1) ]

# get the angles in degrees
angValsWrong = dataRaw[:Angle]

# correct angles
angVals = map(x -> 180 - x, angValsWrong)

# get value-uncertainty pairs for angles
angs = getListOfPairs(angVals, fill(angErr, (1,length(angVals))))

# -----------END INPUT DATA-----------

# ----------BEGIN ERROR PROPAGATION----------

# get the bit of error for a variable into a 1-variable function
propUncert1Var(func, (val, err)) = (derivative(func, val) * err) ^ 2

# the propagated uncertainty of a particular value with 1-var function
#propUncert1Var(func, valErrs) = sqrt(sum([ sqDer1Var(func, valErr[1], valErr[2]) 
#                                       for valErr in valErrs ])) 

# run a list of val-err pairs through a function
getValErrs(func, pairs) = 
    getListOfPairs(map(func, map(x -> x[1], pairs)), 
                   map(x -> propUncert1Var(func, x), pairs))

# -----------END ERROR PROPAGATION-----------

# ----------BEGIN WAVELENGTH FUNCTIONS----------

# index of refraction of prism
indRef(ang) = sqrt(((((2 * sin(deg2rad(ang))) / sqrt(3)) + (1/2)) ^ 2) + (3/4))

# wavelength of light with constants A=13900 and B=1.689
wl(indRef) = sqrt(13900 / (indRef - 1.689))

# -----------END WAVELENGTH FUNCTIONS-----------

# ----------BEGIN CALCULATE WAVELENGTH----------

# make the value-uncertainty pairs for indices of refraction, given the angles
indRefs = getValErrs(indRef, angs)

# get the value-uncertainty pairs for the wavelengths, given the indices of ref.
wls = getValErrs(wl, indRefs) 

# -----------END CALCULATE WAVELENGTH-----------

## display wavelengths
for wl in wls
    @printf("%.2e %.2e\n", wl[1], wl[2])
end

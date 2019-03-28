# ----------BEGIN PACKAGES----------

# for reading data
using CSV

# for storing data
using DataFrames

# for displaying data
using Printf

# for getting the mean
using Statistics

# -----------END PACKAGES-----------

# ----------BEGIN EXTRACT DATA----------

# check for variable containing CL arguments without overwriting system ARGS
#locARGS = isdefined(:newARGS,1) ? newARGS : ARGS

# get path to the data file from the command line
filepath = ARGS[1]
#filepath = "../Plots/ExpSmallCoil/expSmallCoil.csv"

# throw the data into a DataFrame
dataRaw = CSV.File(filepath) |> DataFrame

# put two columns from a data frame into a list of tuples
getListOfPairsDF(dataFrame, col1, col2) = 
    [ (dataFrame[col1][ii], dataFrame[col2][ii]) for ii in 1:size(dataFrame)[1] ]

# put combine two lists (of same size) into a list of pairs
getListOfPairs(l1, l2) = [ (l1[ii], l2[ii]) for ii in 1:length(l1) ]

# get the values and corresponding errors in the voltages
volts = getListOfPairsDF(dataRaw, :Voltage, :VError)

# get the values and corresponding errors in the resistances
ress = getListOfPairsDF(dataRaw, :Resistance, :ResError)

# get the values and corresponding errors in the frequencies
freqs = getListOfPairsDF(dataRaw, :CorrFreq, :FreqError)

# -----------END EXTRACT DATA-----------

# ----------BEGIN GENERAL ERROR PROPAGATION----------

# get \( \frac{\delta x}{x}^2 \)
sqErrRatio(dataPt) = (dataPt[2] / dataPt[1]) ^ 2

# get the uncertainty of a value calculated via multiplication of measurements
propUncertMult(val, meas) = val * sqrt(sum(map(sqErrRatio, meas)))

# -----------END GENERAL ERROR PROPAGATION-----------

# ----------BEGIN CURRENT----------

# get the calculated values for the current
currVals = [ volts[ii][1] / ress[ii][1] for ii in 1:length(volts) ]

# get the uncertainties of the current
currUncerts = [ propUncertMult(currVals[ii], [ volts[ii], ress[ii] ]) 
                for ii in 1:length(currVals) ]

# combine the values and uncertainties into pairs
currs = getListOfPairs(currVals, currUncerts)

# -----------END CURRENT-----------

# ----------BEGIN MAGNETIC FIELD----------

# given a current, find the resultant magnetic field using:
# \( B = \mu_0 \frac{4}{5}^{\frac{3}{2}} \frac{n}{r} I
magField(curr) = (4e-7 * pi) * ((4/5)^(3/2)) * (320 / 0.067) * curr

# get the value-uncertainty pairs for the magnetic field
magFields = getListOfPairs(map(magField, map(x -> x[1],currs)), 
                           map(magField, map(x -> x[2],currs))) 

# -----------END MAGNETIC FIELD-----------

# ----------BEGIN G-FACTOR----------

# calculate the g-factor from the magnetic field and frequency:
# \( \frac{h \nu}{\mu_B B} \)
gFac(freq, magField) = (6.626e-34 * freq) / (9.274e-24 * magField)

# get the g-factors from frequency and magnetic field lists of equal length
gFacVals = [ gFac(freqs[ii][1], magFields[ii][1]) for ii in 1:length(freqs) ]

# get the uncertainties in the g-factors
gFacErrs = [ propUncertMult(gFacVals[ii], [ freqs[ii], magFields[ii] ]) 
             for ii in 1:length(gFacVals) ]

# combine the values and errors into a list of pairs
gFacs = getListOfPairs(gFacVals, gFacErrs)

# -----------END G-FACTOR-----------

# the mean of the g-factors
meanGFac = mean(gFacVals)

# the mean of the uncertainties of the g-factors
meanGFacErr = std(gFacVals) / sqrt(length(gFacVals))

# display mean g-factor info
@printf("%.4e %.4e\n", meanGFac, meanGFacErr)

# display g-factor error
#for fac in gFacErrs
#    @printf("%.4e\n", fac)
#end

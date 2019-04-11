# Determine the Planck constant from \( e V_0 = h f - W \)

# ----------BEGIN PACKAGES----------

# read CSVs
using CSV

# pretty data structure
using DataFrames

# for error propagation
using Calculus

# pretty printing
using Printf

# for convenient mean calculation
using Statistics

# -----------END PACKAGES-----------

# ----------BEGIN CONSTANTS----------

# elementary charge (\si{\coloumb})
eleChg = 1.60e-19

# work function of Mercury (\si{\electron\volt})
WHg = 4.5 * eleChg

# speed of light ( \si{\meter\per\second} )
cLight = 3e8

# -----------END CONSTANTS-----------

# ----------BEGIN INPUT----------

# path to data file
filepath = ARGS[1]
#filepath = newARGS[1]

# throw data into DataFrame
dataRaw = CSV.read(filepath) |> DataFrame

# put combine two lists (of same size) into a list of pairs
getListOfPairs(l1, l2) = [ (l1[ii], l2[ii]) for ii in 1:length(l1) ]

# all the val-err pairs for the stopping potential
stopPots = getListOfPairs(
    map(x -> x * 1e-3, dataRaw[:StopPotVal]), 
    map(x -> x * 1e-3, dataRaw[:StopPotErr]))

# all the values of the estimated light frequencies
estWls = dataRaw[:EstFreq]
estCorrWls = map(x -> x * 1e-9, estWls)
estFreqVals = map(x -> cLight / x, estCorrWls)

# combine the val-err potential pairs with their corresponding frequency
potFreqPairs = getListOfPairs(stopPots, estFreqVals)

# -----------END INPUT-----------

# ----------BEGIN PLANCK CONSTANT----------

# get Planck constant
getPlanck((pot, freq)) = ((eleChg * pot) + WHg) / freq

# get uncertainty of Planck constant with uncertain potential
getPlanckErr(potErr, freq) = (eleChg / freq) * potErr
#(derivative(x -> getPlanck(x, freq), potVal) * potErr)

# get the values of the Planck constant through each filter
planckVals = map(getPlanck, getListOfPairs(
    map(x -> x * 1e-3, dataRaw[:StopPotVal]), estFreqVals))

# get uncertainties of Planck constant through each filter
#planckErrs = map(getPlanckErr, potFreqPairs)
planckErrs = [getPlanckErr(pair[1][2], pair[2]) for pair in potFreqPairs]

# get the val-err pairs for the Planck constant of each filter
plancks = getListOfPairs(planckVals, planckErrs)

# -----------END PLANCK CONSTANT-----------

# display results
#@printf("PVal PErr\n")
#for pair in plancks
#    @printf("%e %e\n", pair[1], pair[2])
#end

# display mean
@printf("%e %e\n", mean(planckVals), std(planckVals) / sqrt(length(planckVals)))

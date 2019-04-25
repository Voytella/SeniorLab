# Given a list of time intervals, provide progressed time.

# ----------BEGIN PACKAGES----------

# read CSVs
using CSV

# pretty data structure
using DataFrames

# pretty printing
using Printf

# -----------END PACKAGES-----------

# ----------BEGIN INPUT----------

# get the path to the data file
#filepath = ARGS[1]
filepath = newARGS[1]

# throw data into a DataFrame
dataRaw = CSV.read(filepath)

# grab time intervals
ints = dataRaw[:Int]

# -----------END INPUT-----------

# ----------BEGIN TIME----------

# storage for current progressive times
curTime = 0.0

# get progressive times
getTimes(curTime, ints) = 

# progressive times
times = getTimes

# -----------END TIME-----------

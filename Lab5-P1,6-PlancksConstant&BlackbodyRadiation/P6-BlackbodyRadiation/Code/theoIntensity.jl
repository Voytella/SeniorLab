# generate data points for the intensity from the wavelengths measured

# ----------BEGIN PACKAGES----------

# to read CSVs
using CSV

# to throw CSV data into a pretty data structure
using DataFrames

# pretty printing
using Printf

# -----------END PACKAGES-----------

# ----------BEGIN CONSTANTS----------

# speed of light \( \si{\meter\per\second} \)
cLight = 3e8

# Planck's constant \( \si{\square\meter\kilo\gram\per\second} \)
h = 6.626e-34

# Boltzmann constant \( \si{\square\meter\kilo\gram\per\square\second\per\kelvin} \)
kB = 1.38e-23

# -----------END CONSTANTS-----------

# ----------BEGIN INPUT----------

# the theoretical temperature of the filament
temp = parse(Float64, ARGS[1])
#temp = newARGS[1]

# the path to the file where the wavelengths are stored
filepath = ARGS[2]
#filepath = newARGS[2]

# grab the wavelengths from the file
dataRaw = CSV.File(filepath) |> DataFrame

# extract wavelengths
wlVals = dataRaw[:wlVal]

# -----------END INPUT-----------

# ----------BEGIN INTENSITY FUNCTIONS----------

# calculate the intensity with wavelength and temperature
getIntensity(wl, temp) =
    ((2 * pi * (cLight ^ 2) * h) / (wl ^ 5)) *
    ( 1 / (exp((h * cLight) / (wl * kB * temp)) - 1) )

# get the intensities
intensityVals = map(x -> getIntensity(x, temp), wlVals)

# -----------END INTENSITY FUNCTIONS-----------

# display intensities
print("CalcInts\n")
for ii in intensityVals
    @printf("%e\n", ii)
end

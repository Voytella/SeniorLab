# Calculate theoretical intensity from provided wavelength and temperature.

# ----------BEGIN PACKAGES----------

# for doing fancy math
using Calculus

# for pretty printing
using Printf

# -----------END PACKAGES-----------

# ----------BEGIN CONSTANTS----------

# resistivity of tungsten at room temperature
# (\( \frac{\si{\micro\ohm}}{\si{\centi\meter}} \))
resW = 5.65

# resistance of bulb (\( \si{\ohm} \))
resBulb = 0.93

# speed of light \( \si{\meter\per\second} \)
cLight = 3e8

# Planck's constant \( \si{\square\meter\kilo\gram\per\second} \)
h = 6.626e-34

# Boltzmann constant \( \si{\square\meter\kilo\gram\per\square\second\per\kelvin} \)
kB = 1.38e-23

# -----------END CONSTANTS-----------

# ----------BEGIN DATA IMPORT----------

# get the voltage applied to the bulb
#voltIn = parse(Float64, ARGS[1])
voltIn = newARGS[1]

# get the uncertainty in the applied voltage
#voltErr = parse(Float64, ARGS[2])
voltErr = newARGS[2]

# get the current applied to the bulb
#currIn = parse(Float64, ARGS[3])
currIn = newARGS[3]

# get the uncertainty in the applied current
#currErr = parse(Float64, ARGS[4])
currErr = newARGS[4]

# -----------END DATA IMPORT-----------

# ----------BEGIN ERROR PROPAGATION----------

# get \( \left( \frac{\delta x}{x} \right)^2 \)
sqErrRatio(dataPt) = (dataPt[2] / dataPt[1]) ^ 2

# get the uncertainty of a value calculated via multiplication of measurements
propUncertMult(val, meas) = val * sqrt(sum(map(sqErrRatio, meas)))

# get the uncertainty in a variable thrown into a 1-var function
propUncert1Var(func, (val, err)) = (derivative(func, val) * err) ^ 2

# -----------END ERROR PROPAGATION-----------

# ----------BEGIN TEMPERATURE CALCULATIONS----------

# calculate the resistivity
resyVal = resW * ( ((voltIn / currIn) - 0.2) / (resBulb) )

# calculate the uncertainty in the resistivity
resyErr = propUncertMult(resyVal, [(voltIn, voltErr), (currIn, currErr)])

# calculate the temperature from the resistivity
getTemp(r) = 103 + (38.1 * r) - (0.095 * (r ^ 2)) + ( 2.48e-4 * (r ^ 3))

# get the value of the temperature
tempVal = getTemp(resyVal)

# calculate the uncertainty in the temperature
tempErr = propUncert1Var(getTemp, (resyVal, resyErr))

# -----------END TEMPERATURE CALCULATIONS-----------

# ----------BEGIN WAVELENGTH CALCULATIONS----------

# calculate the maximum wavelength of the emitted light
wlVal = 0.002898 / tempVal

# calculate the uncertainty in the wavelength
wlErr = 0.002898 / tempErr

# -----------END WAVELENGTH CALCULATIONS-----------

# display results


# ----------BEGIN INTENSITY FUNCTIONS----------

# calculate the intensity with wavelength and temperature
getIntensity(wl, temp) = 
    ((2 * pi * (cLight ^ 2) * h) / (wl ^ 5)) *
    ( 1 / (exp((h * cLight) / (wl * kB * temp)) - 1) )

# wl and temp are val-err pairs
intGrad = Calculus.gradient(x -> getIntensity(x[1], x[2]), [wlVal, tempVal]) 

# a partial multiplied by the error of the partial's value, all squared
mkErrSq(part, err) = (part * err) ^ 2

# get the intensity
intensityVal = getIntensity(wlVal, tempVal)

# calculate the uncertainty in the intensity
intensityErr = sqrt(mkErrSq(intGrad[1], wlErr) + mkErrSq(intGrad[2], tempErr))
    
# -----------END INTENSITY FUNCTIONS-----------

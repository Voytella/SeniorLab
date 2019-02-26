# ----------BEGIN AUXILIARY FUNCTIONS----------

# avogadro's number
avoNum = 6.022e23

# get the mean of a numeric list
getAvg(list) =  sum(list) / length(list)

# convert degrees to radians
deg2rad(angle) = (pi / 180) * angle

# convert radians to degrees
rad2deg(angle) = (180 / pi) * angle

# -----------END AUXILIARY FUNCTIONS-----------

# ----------BEGIN GENERAL FUNCTIONS----------

# incident rate of beam (triggers per second)
incidentRate = 30.8

# get the direct scattering
scatRateD(mean, time) = mean / time

# get the spacial scattering rate
scatRateS(angleRad, dirScatRate) = 2 * pi * sin(angleRad) * dirScatRate

# get the scattering rate for an angle in degrees
getScatRate(angle, data, time) = 
    scatRateS(deg2rad(angle), scatRateD(getAvg(data), time))

# get density of scatterers (gold nuclei in the way)
scatDensity(matDen, thickness, massNumber) = 
    (matDen * avoNum * thickness) / massNumber

# the solid angle of the incident beam 
findSolidAngle(incidentArea, distTraveled) = incidentArea / (distTraveled ^ 2)

# cross sectional area
crossSecArea(scatRate, incidentRate, scatDensity, solidAngle) =
    scatRate / (incidentRate * scatDensity * solidAngle)

# -----------END GENERAL FUNCTIONS-----------

# ----------BEGIN SPECIFIC FUNCTIONS----------

# the scattering density of our piece of gold
scatDenGold = scatDensity(19.3e6, 2e-6, 197)

# the solid angle for our detector
solidAngle = findSolidAngle(9.13e-6, 1.97e-2)

# get cross sectional area for our setup
getCrossSecArea(angle, data, time) = 
    crossSecArea(getScatRate(angle, data, time), 
                 incidentRate, scatDenGold, solidAngle)

# -----------END SPECIFIC FUNCTIONS-----------


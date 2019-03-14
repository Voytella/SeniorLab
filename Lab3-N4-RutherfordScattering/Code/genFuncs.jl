# a collection of useful functions used by other pieces of code

# ----------BEGIN CONSTANTS----------

# avogadro's number
avoNum = 6.022e23

# elementary charge (Coulombs)
eleChg = 1.6021e-19

# dielectric constant ( \( \frac{A s}{V m} \) )
ε = 8.8524e-12

# alpha particle for Americium-241 in eV
AmAlphaDecayEng = 5.486e6

# alpha particle for Americium-241 in Joules
αEngAm241 = 8.789541e-13

# -----------END CONSTANTS-----------

# ----------BEGIN AUXILIARY FUNCTIONS----------

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

# differential cross section
diffCrossSec(atomicNumProj, atomicNumTarget, αEng, angle) =
    (((atomicNumProj * atomicNumTarget * (eleChg ^ 2)) / (4 * pi * ε)) ^ 2) * 
    ((1 / (4 * αEng)) ^ 2) * 
    ( 1 / (sin(deg2rad(angle)) ^ 4))

# -----------END GENERAL FUNCTIONS-----------

# ----------BEGIN SPECIFIC FUNCTIONS----------

# the scattering density of our piece of gold
scatDenGold = scatDensity(19.3e4, 2e-6, 197)

# the scattering density of our piece of aluminum
scatDenAl = scatDensity(2.7e4, 1.5e-5, 27)

# the solid angle for our detector
solidAngle = findSolidAngle(9.13e-6, 1.97e-2)

# get cross sectional area for our setup with Gold
getCrossSecAreaGold(counts, time, angle) = 
    crossSecArea(getScatRate(angle, counts, time), 
                 incidentRate, scatDenGold, solidAngle)

# differential cross section for our setup with Gold
getDiffCrossSecGold(angle) = diffCrossSec(2, 79, αEngAm241, angle)

# get cross sectional area for our setup with Aluminum
getCrossSecAreaAl(counts, time, angle) =
    crossSecArea(getScatRate(angle, counts, time), 
                 incidentRate, scatDenAl, solidAngle)

# differential cross section of our setup with Aluminum
getDiffCrossSecAl(angle) = diffCrossSec(2, 13, αEngAm241, angle)

# find the nuclear number of aluminum when compared to gold
nucNumAl(scatRateAl, scatRateAu, matDenAl, matDenAu) =
    sqrt( (scatRateAl * matDenAu * (79 ^ 2)) / (scatRateAu * matDenAl) )

# -----------END SPECIFIC FUNCTIONS-----------

# ----------BEGIN THEORETICAL FUNCTIONS----------

# Rutherford Scattering Formula
scatRateTheo(scatDen, atomicNum, αEng, angle) =
    (incidentRate * scatDen * (atomicNum ^ 2) * (eleChg ^ 4)) /
    ( ((8 * pi * ε * αEng) ^ 2) * (sin(deg2rad(angle / 2)) ^ 4) )

# theoretical cross section by throwing in the theoretical scattering rate
crossSecAreaTheo(scatDen, atomicNum, αEng, angle) =
    crossSecArea(scatRateTheo(scatDen, atomicNum, αEng, angle),
                 incidentRate, scatDen, solidAngle)

# -----------END THEORETICAL FUNCTIONS-----------

include("genFuncs.jl")

using Printf
using Measurements

# performs error propagation
uncertFunc(func, dataPt) = @uncertain (func)(dataPt)

# run each data point through the provided function
uncertainties(func, vals) = map(x -> uncertFunc(func, x), vals)

# each experimental data point for which the cross section will be determined
trips = [
    #(0,900,-30),
    (2.5,600,-25),
    (1.6,200,-20),
    (2.6,100,-15),
    (2.4,100,-10),
    (68.2,100,-5),
    (899,100,-2.5),
    #(2717,100,0),
    (2791,100,1.25),
    (2539,100,2.5),
    (1278.6,100,5),
    (5.4,100,10),
    (1.2,100,15),
    (1.6,200,20),
    #(1,600,25),
    #(0,900,30)
]

# slap an uncertainty onto each of the angles
anglesWithUncert = [measurement(z,1.0) for (x,y,z) in trips]

# list of exp. cross section functions without the angles having been applied
#crossSecExpFuncs = [ anonAng -> getCrossSecArea(counts, time, anonAng) for
#                              (counts, time, angle) in trips ]

# print the uncertainties for each cross sectional area
for pt in uncertainties(getDiffCrossSecGold, anglesWithUncert)
    print(Measurements.value(pt))
    print(" ")
    print(Measurements.uncertainty(pt))
    print("\n")
end

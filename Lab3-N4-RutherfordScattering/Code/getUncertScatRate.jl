include("genFuncs.jl")

using Measurements

# performs error propagation
uncertFunc(func, dataPt) = @uncertain (func)(dataPt)

# takes a list of function-value pairs and calculates each one's uncertainty
uncertaintiesAu(funcsNVals) = [ uncertFunc(func, val) for (func, val) in
                              funcsNVals ]

# calculate the experimental scattering rate
scatRateExpAu(counts, time, angle) = 
    2 * pi * sin(deg2rad(angle)) * (counts / time)

# each experimental data point for which the scattering rate will be determined
tripsAu = [
    (2.5,600,-25),
    (1.6,200,-20),
    (2.6,100,-15),
    (2.4,100,-10),
    (68.2,100,-5),
    #(899,100,-2.5),
    #(2791,100,1.25),
    #(2539,100,2.5),
    (1278.6,100,5),
    (5.4,100,10),
    (1.2,100,15),
    (1.6,200,20),
]

# slap an uncertainty onto each of the angles
anglesWithUncertAu = [measurement(z,1.0) for (x,y,z) in tripsAu]

# list of exp. scattering rate functions without the angles having been applied
scatRateExpFuncsAu = [ anonAng -> scatRateExpAu(counts, time, anonAng) for
                              (counts, time, angle) in tripsAu ]

# print the uncertainties for each scattering rate
for pt in uncertaintiesAu(zip(scatRateExpFuncsAu, anglesWithUncertAu))
    print(Measurements.uncertainty(pt))
    print("\n")
end

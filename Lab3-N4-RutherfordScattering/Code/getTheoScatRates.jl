include("genFuncs.jl")

angleList = -30:5:30
theoScatRates = map(x -> scatRateTheo(scatDenGold, 79, αEngAm241, x), angleList)

# print headers
print("X")
print(" ")
print("Y")
print("\n")

# print data
for ii in 1:length(theoScatRates)
    print(angleList[ii])
    print(" ")
    print(theoScatRates[ii])
    print("\n")
end

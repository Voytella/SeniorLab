# ----------BEGIN PACKAGES----------

# enable the addition of packages
using Pkg

# integration
Pkg.add("QuadGK")
using QuadGK

# 3D plotting
Pkg.add("Plots")
using Plots

using Printf

# -----------END PACKAGES-----------

# ----------BEGIN CONSTANTS----------

# Permeability of Free Space (T*m)/A
μ₀ = 1.256e-6

# -----------END CONSTANTS-----------

# ----------BEGIN BIOT-SAVART ON AXIS----------

# Biot-Savart (one loop, on axis)
B1(z,I,a) = ((μ₀ * I * (a ^ 2)) / 2) * (1 / (((a ^ 2) + (z ^ 2)) ^ (3/2)))
    
# Biot-Savart (two loops, on axis)
B2(z,I,a) = ((μ₀ * I * (a ^ 2)) / 2) * 
    ((1 / (((a ^ 2) + (z ^ 2)) ^ (3/2))) + 
     (1 / (((a ^ 2) + ((a - z) ^ 2)) ^ (3/2))))

# -----------END BIOT-SAVART ON AXIS-----------

# ----------BEGIN BIOT-SAVART OFF AXIS----------

# the full Biot-Savart equation (two loops, off axis)
B(z,I,N,a,ρ) = 
    ((μ₀ * I * N) / (2 * pi) ) *
    ( 
        (1 / sqrt(( (a + ρ) ^ 2) + ((a - z) ^ 2))) *
        ( 
            K(1,a,ρ,z) + 
            (
                (((a ^ 2) - (ρ ^ 2) - ((a - z) ^ 2)) / 
                 (((a - ρ) ^ 2) + ((a - z) ^ 2))) * 
                E(1,a,ρ,z)
            )
        ) +
        ( 
            (1 / sqrt(((a + ρ) ^ 2) + (z ^ 2))) * 
            (
                K(2,a,ρ,z) + 
                (
                    (((a ^ 2) - (ρ ^ 2) - (z ^ 2)) / 
                     (((a - ρ) ^ 2) + (z ^ 2))) * 
                    E(2,a,ρ,z)
                )
            ) 
        ) 
    )
        
# elliptic integrals of first kind (series expansion)
K(j,a,ρ,z, precision = 4) = 
    (pi / 2) * (
        1 + sum([ 
            ((reduce(*, [n - 1 for n in 2:2:precision]) / 
              reduce(*, [n for n in 2:2:precision])) ^ 2) * 
            (k(j,a,abs(ρ),z) ^ n) 
            for n in 2:2:precision
        ])
    )
        
# elliptic integrals of the second kind (series expansion)
E(j,a,ρ,z, precision = 4) =
    (pi / 2) * (
        1 - foldl(-,[
            ((reduce(*, [n-1 for n in 2:2:precision]) / 
              reduce(*, [n for n in 2:2:precision])) ^ 2) * 
            ((k(j,a,abs(ρ),z) ^ n) / (n-1))
            for n in 2:2:precision
        ])
    )
    
# the collections of variables k₁ and k₂
k(j,a,ρ,z) = (j == 1) ? 
    sqrt((4 * a * ρ) / (((a + ρ) ^ 2) + ((a - z) ^ 2))) :
    sqrt((4 * a * ρ) / (((a + ρ) ^ 2) + (z ^ 2)))

# -----------END BIOT-SAVART OFF AXIS-----------

# ----------BEGIN CONDITIONS----------

# heights at which measurements were taken (meters)
heightLevels = 0.03:0.02:0.33

# current applied to the coils (amperes)
current = 2

# turns of wire in each coil
turns = 73

# radius of the coils (meters)
radius = 0.332

# radial distances at which measurements were taken (meters)
rhos = -0.22:0.02:0.22

# -----------END CONDITIONS-----------

# ----------BEGIN CALCULATIONS----------

# list of Biot-Savart functions for each height level
BHeights = [ futureRho -> B(heightLevel, current, turns, radius, futureRho) * 1e6
            for heightLevel in heightLevels ]

# apply the list of radial distances to each height level's function (rhos are rows)
#allBs = [ map(heightLevelFunction, map(abs, rhos)) for heightLevelFunction in BHeights ]
allBs = [ map(heightLevelFunction, rhos) for heightLevelFunction in BHeights ]

# -----------END CALCULATIONS-----------

# ----------BEGIN MAKE DATA POINTS----------

# convert column number (1:23) to radial distance value (-22:2:22)
colNum2RadialDist(col) = col + (col - 24)

# convert row number (1:16) to height value (3:2:33)
rowNum2Height(row) = row + (row + 1)

# data points for a row of data at the same height level
getRow(row) = [ (rowNum2Height(row), colNum2RadialDist(col), allBs[row][col]) 
                for col in 1:23 ]

# data points as triples with rows as heights and columns as radial distances
allPts = map(getRow, 1:16)

# -----------END MAKE DATA POINTS-----------

# ----------BEGIN FORMAT DATA----------

# split up coords into their own lists
formatRow(row) = ( [ coords[1] for coords in row ],
                   [ coords[2] for coords in row ],
                   [ coords[3] for coords in row ] )

# format all rows
listOfRows = map(formatRow, allPts)

# now, a "row" is of the form ([zs], [rs], [Bs]); all these lists must be combined
tripleData = ( foldl(hcat, map(x -> x[1], listOfRows)),
                     foldl(hcat, map(x -> x[2], listOfRows)),
                     foldl(hcat, map(x -> x[3], listOfRows)) )

# print the data in neat columns
function displayFormatedData(data) 
    
    # print header
    @printf("z ρ B\n")

    # iterate through each data point
    for ii in 1:length(data[1])
        @printf("%f %f %f\n", data[1][ii], data[2][ii], data[3][ii])
    end

end

# -----------END FORMAT DATA-----------

plt3d = Plots.plot(tripleData[3], tripleData[2], tripleData[1], 
                   seriestype = :scatter, legend = :topright, legendtitle = "Rows",
                   title = "Theoretical Magnetic Field", size = (550,550),
                   xlabel = "Magnetic Field Strength (uT)",
                   ylabel = "Height Relative to Bottom Coil (cm)",
                   zlabel = "Radial Distance from Axis (cm)"
                   )
savefig("3DPlotTheoretical.png")

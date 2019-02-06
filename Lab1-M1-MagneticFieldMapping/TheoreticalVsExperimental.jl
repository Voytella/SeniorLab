# Plot the difference between the theoretical and experimental data.

# ----------BEGIN PACKAGES----------

# enable the addition of packages
using Pkg

# interpreter for reading CSV files
Pkg.add("CSV")
using CSV

# convenient container for data extracted from CSV files
Pkg.add("DataFrames")
using DataFrames

# plotting
Pkg.add("Plots")
using Plots

# ----------BEGIN GENERATE THEORETICAL DATA----------

# Permeability of Free Space \( \frac{T m}{A} \)
μ₀ = 1.256e-6

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

# list of Biot-Savart functions for each height level
BHeights = [ futureRho -> B(heightLevel, current, turns, radius, futureRho) * 1e6
            for heightLevel in heightLevels ]

# apply the list of radial distances to each height level's function (rhos are rows)
# list of lists of Bs where each internal list is a row
theoBs = [ map(heightLevelFunction, rhos) for heightLevelFunction in BHeights ]

# -----------END GENERATE THEORETICAL DATA-----------

# ----------BEGIN EXTRACT EXPERIMENTAL DATA----------

# read data from CSV into a DataFrame
data = CSV.File("2dMappingTesla.csv") |> DataFrame

# convert row number (1:16) to height value (3:2:33)
rowNum2Height(row) = row + (row + 1)

# reverse the order of the incoming heights
heightReversal(z) = z + (16 - (z - 1) - z)

# apply corrections to data (Earth's magnetic field & correct units)
corrB(b) = ((b + 0.000024) * 1e6) 

# extract the data from a row into a triple representing that row
extractRow(row) = (
    fill(rowNum2Height(row), 23),
    -22:2:22,
    [ corrB(Bval) for Bval in [ data[ii][heightReversal(row) ] for ii in 2:24 ] ]
)

# list of triples, each representing a row
expRows = map(extractRow, 1:16)

# -----------END EXTRACT EXPERIMENTAL DATA-----------

# ----------BEGIN PLOT THE DIFFERENCE----------

# list of triples, each representing a row, where the Bs are (theoB-expB)
diffRows = [ (expRows[ii][1], expRows[ii][2], theoBs[ii] .- expRows[ii][3]) 
             for ii in 1:length(expRows) ]

# now, a "row" is of the form ([zs], [rs], [Bs]); all these lists must be combined
tripleData = ( foldl(hcat, map(x -> x[1], diffRows)),
               foldl(hcat, map(x -> x[2], diffRows)),
               foldl(hcat, map(x -> x[3], diffRows)) )

# plot the difference between the theoretical and experimental data
diffPlot = Plots.plot(tripleData[3], tripleData[2], tripleData[1], 
                   seriestype = :scatter, legend = :topright, legendtitle = "Rows",
                   title = "Difference Between Theoretical and Experimental Magnetic Field", 
                   size = (550,550),
                   xlabel = "Magnetic Field Strength (uT)",
                   ylabel = "Height Relative to Bottom Coil (cm)",
                   zlabel = "Radial Distance from Axis (cm)"
                   )

# save the plot to disk
savefig("3DPlotDiff.png")

# -----------END PLOT THE DIFFERENCE-----------

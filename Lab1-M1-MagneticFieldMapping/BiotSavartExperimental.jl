using DataFrames
using CSV
using Printf
using Plots

# ----------BEGIN EXTRACT DATA----------

# read data from CSV into a DataFrame
data = CSV.File("2dMappingTesla.csv") |> DataFrame

# convert row number (1:16) to height value (3:2:33)
rowNum2Height(row) = row + (row + 1)

# reverse the order of the incoming heights
heightReversal(z) = z + (16 - (z - 1) - z)

# extract the data from a row into a triple representing that row
extractRow(row) = (
    fill(rowNum2Height(row), 23), 
    -22:2:22, 
    [(Bval + 0.000024) * 1e6 for Bval in [data[ii][heightReversal(row)] for ii in 2:24]]
)

# list of triples, each representing a row
extractData = map(extractRow, 1:16)

# -----------END EXTRACT DATA-----------

# ----------BEGIN FORMAT DATA----------

# now, a "row" is of the form ([zs], [rs], [Bs]); all these lists must be combined
tripleData = ( foldl(hcat, map(x -> x[1], extractData)),
               foldl(hcat, map(x -> x[2], extractData)),
               foldl(hcat, map(x -> x[3], extractData)) )

# print the data in neat columns (display only, does not need to be included)
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
                   seriestype = :scatter, legend = :topleft, 
                   legendtitle = "Rows",
                   title = "Experimental Magnetic Field", size = (550,550), 
                   xlabel = "Magnetic Field Strength (uT)",
                   ylabel = "Height Relative to Bottom Coil (cm)",
                   zlabel = "Radial Distance from Axis (cm)"
                   )
savefig("3DPlotExperimental.png")

# create a table of the value of \( x_n \) for different values of \( r \) for a
# given number of iterations 

# ----------BEGIN PACKAGES----------

# pretty printing
using Printf

# -----------END PACKAGES-----------

# ----------BEGIN INPUT----------

# value of initial condition
initCond = parse(Float64, ARGS[1])
#initCond = newARGS[1]

# the number of \( x_n \)s to calculate for each \( r \)
iterations = parse(Int, ARGS[2])
#iterations = newARGS[2]

# range of \( r \)s to test
rs = 1.0:0.1:4.0

# must be global for "include"
lyaARGS = []

# -----------END INPUT-----------

# ----------BEGIN PAIR GENERATION----------

# print headers
@printf("r xn\n")

# generate and display \( x_n \), \( r \) pairs
for r in rs
   
    # generate 'lyaARGS' for "Lyapunov.jl"
    global lyaARGS = [initCond, r, iterations]

    # Lyapunov functions (includes Calculus package)
    include("Lyapunov.jl")

    # calculate \( x_n \) for the provided \( r \)
    xn = solveLogFunc(initCond, r, 0, iters)

    # print \( x_n \), \( r \) pairs
    @printf("%f %f\n", r, xn)

end
# -----------END PAIR GENERATION-----------

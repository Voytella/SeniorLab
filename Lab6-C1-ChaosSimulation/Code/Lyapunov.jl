# calculate the Lyapunov exponent over a given number of iterations
# for a given initial condition and r

# ----------BEGIN PACKAGES----------

# derive the provided function
using Calculus

# -----------END PACKAGES-----------

# ----------BEGIN CONSTRUCT CHAOS FUNCTION----------

# get value of initial condition
#initCond = ARGS[1]
initCond = lyaARGS[1]

# get value of 'r'
#r = ARGS[2]
r = lyaARGS[2]

# get number of iterations
#iters = ARGS[3]
iters = lyaARGS[3]

# solve the logistic function
function solveLogFunc(initCond, r, curIter, totIters)
    
    # base case
    if (curIter == 0)
        if (totIters == 0)
            return logFunc(r,initCond)
        end
        return solveLogFunc(initCond, r, curIter + 1, totIters - 1)
    end

    # recursive step
    if (totIters != 0)
        return solveLogFunc(
            solveLogFunc(initCond, r, 0, curIter), 
            r, curIter + 1, totIters -1)
    end

    # composition step
    if (totIters == 0)
        return (r * initCond) * (1 - initCond)
    end
end

# logistic function
logFunc(r,x) = (r * x) * (1 - x)

# -----------END CONSTRUCT CHAOS FUNCTION-----------

# ----------BEGIN FIND LYAPUNOV----------

# Lyapunov function sans the limit part
lya(iters, func, initCond, r) = (1 / iters) * sum( [ 
    log(abs(derivative(func, solveLogFunc(initCond, r, 0, ii)))) 
    for ii in 0:iters ] )

# -----------END FIND LYAPUNOV-----------

# ----------BEGIN PACKAGES----------

# pretty displaying formatting
using Printf

# -----------END PACKAGES-----------

# ----------BEGIN CONSTANTS----------

# resistivity of tungsten at room temperature 
# (\( \frac{\si{\Ohm}}{\si{\meter}} \))
rW = 5.65e-4 

# resistance of bulb (\( \si{\Ohm} \))
resBulb = 0.93

# -----------END CONSTANTS-----------

# ----------BEGIN INPUT----------

# voltage applied to the bulb
inVolt = ARGS[1]

# current applied to the bulb
inCurr = ARGS[2]

# -----------END INPUT-----------

# ----------BEGIN TEMPERATURE CALCULATIONS----------

# get the resistivity
r = rW * ( ((inVolt / inCurr) - 0.2) / (resBulb) )

# get the temperature from the resistivity
temp(r) = 103 + (38.1 * r) - (0.095 * (r ^ 2)) + ( 2.48e-4 * (r ^ 3))

# -----------END TEMPERATURE CALCULATIONS-----------

# display temperature
@printf("%.2e\n", temp(r))

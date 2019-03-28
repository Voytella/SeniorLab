# ----------BEGIN PACKAGES----------



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

# get the resistivity
r = rW * ( ((inVolt / inCurr)) / () )

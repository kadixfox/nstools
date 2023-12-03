#!/usr/bin/env python3.9
import census_maximizer as cm
import sys

USER     = sys.argv[1]
PASSWORD = sys.argv[2]
CONTACT  = sys.argv[3]

cm.init(CONTACT)
solver = cm.CensusMaximizer(USER, PASSWORD)
solver.adjust_weights(census = {
    -256    : ("Income Equality",),
    -128    : ("Authoritarianism",),
    128     : ("Corruption",),
    256     : ("Economy",),
    512     : ("Average Income",),
    1024    : ("Economic Output",)
}, policy={
    # some policies idk
})

solver.solve_issues()

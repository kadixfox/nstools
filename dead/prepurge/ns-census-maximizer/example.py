#!/usr/bin/env python3
import census_maximizer as cm
import matplotlib.pyplot as plt
import sys

USER     = sys.argv[1]
PASSWORD = sys.argv[2]
CONTACT  = sys.argv[3]

cm.init(CONTACT)
solver = cm.CensusMaximizer(USER, PASSWORD)
solver.adjust_weights(census = {
    1024  : ("Social Conservatism",),
    512   : ("Authoritarianism",),
    256   : ("Ignorance",),
}, policy={
    # policies
})

solver.solve_issues()

plt.plot(*solver.census_score_history())
plt.show()

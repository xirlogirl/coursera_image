# basic.py

from scipy import ndimage
import scipy
import matplotlib.pyplot as plt
l = scipy.misc.lena()

# slice
l = l[230:290, 220:320]

# gray colour map
plt.imshow(l, cmap=plt.cm.gray, vmin=40, vmax=220)
plt.show()
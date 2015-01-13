# contour.py
# example to plot contours on image

import matplotlib.pyplot as plt
from scipy import ndimage
from scipy import misc

# apparently the lena image is just part of a the scipy misc package?
l = misc.lena()


plt.axis('off')
plt.contour(l, [20, 200])


#plt.imshow(l, cmap=plt.cm.gray, vmin=10, vmax=200)

# or if you jsut want to see a section
plt.subplot(121)

plt.imshow(l[200:220, 200:220], cmap=plt.cm.gray)
plt.axis('off')
plt.subplot(122)
plt.imshow(l[200:220, 200:220], cmap=plt.cm.gray, interpolation='nearest')
plt.axis('off')

plt.show()
from scipy import ndimage
from scipy import misc
#l = misc.lena()
#misc.imsave('lena.png', l) # uses the Image module (PIL)
l = misc.imread('/Users/akanwar/Documents/Image Processing course/assignments/cat.jpg')
import matplotlib.pyplot as plt
l[1:199, 1:230] = 256
plt.imshow(l)
plt.show()
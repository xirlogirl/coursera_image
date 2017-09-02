'''

Simple display example using scipy and matplotlib

'''
import matplotlib.pyplot as plt
from scipy import ndimage
from scipy import misc

IMAGE = '/Users/akanwar/Documents/Image Processing course/assignments/cat.jpg'

#l = misc.lena()
#misc.imsave('lena.png', l) # uses the Image module (PIL)
l = misc.imread(IMAGE)
l[1:199, 1:230] = 256
plt.imshow(l)
plt.show()

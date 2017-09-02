import numpy as np
from copy import copy
import matplotlib.pyplot as plt
from scipy import misc,ndimage
import scipy as sp
import cv2

lena = misc.imread("/Users/akanwar/Documents/Image Processing course/assignments/lena.gif")
# add noise
n=15

m=np.random.normal(0,n,lena.shape)

lena_new=np.array(lena+m,dtype="uint8")

#non local means function
dst=cv2.fastNlMeansDenoising(lena_new,7,21,10)



#compare both images
both=np.hstack((lena_new,dst))
plt.imshow(both,cmap=plt.cm.gray)
plt.show() 

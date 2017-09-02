import numpy as np
import matplotlib.pyplot as plt
from PIL import Image
from scipy import misc


def histeq(im,nbr_bins=256):

   #get image histogram
   imhist,bins = np.histogram(im.flatten(),nbr_bins,normed=True)
   cdf = imhist.cumsum() #cumulative distribution function
   import pdb; pdb.set_trace()
   cdf = 255 * cdf / cdf[-1] #normalize

   #use linear interpolation of cdf to find new pixel values
   im2 = np.interp(im.flatten(),bins[:-1],cdf)

   return im2.reshape(im.shape), cdf

filename = '/Users/akanwar/Documents/Image Processing course/assignments/faded_image.jpg'
im = np.array(Image.open(filename).convert('L'))
#Image.open('plant4.jpg').convert('L').save('inverted.jpg')

im2,cdf = histeq(im)

plt.imshow(im2, cmap=plt.cm.gray)
plt.show()
plt.savefig("outputhisto.jpg")

#Yout histogram equalization code allows for non-integer values in the final image. You can fix it by adding a floor operation to the transform:
#cdf_norm=np.floor(cdf*255/cdf[-1])


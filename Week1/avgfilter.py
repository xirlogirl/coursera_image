import numpy as np
from copy import copy
import matplotlib.pyplot as plt
from scipy import misc

n=10                #averaging number of pixels

# for some reason i couldnt get this to work with pngs, jpg
# seems to be issues with the array size/concatenation. 
# and conversion to grayscale. worked with lena.gif and jpg only
# properties seems the same in matlab.
lena = misc.imread('/Users/akanwar/Documents/Image Processing course/assignments/lena.gif') #load p

v1=np.zeros(shape=(int(n/2),len(lena)))    #create zero vector row
  
lena1=np.r_[v1,lena,v1]           #add v1 to first and last row of lena
    
v0=np.zeros(shape=(len(lena1),int(n/2))) #create zero vec column with new lenghts lena1

lena11=np.c_[v0,lena1,v0]          # add v0 to first and last column in lena1

r,c=lena.shape            # r=row length, c=column length


v=np.zeros(shape=(1,n)) #create zero vector with length n
lena_new=np.empty(shape=(lena.shape)) #create zero matrix 

#the code

for j in range(0,c):
    for i in range(0,r):
        for h in range(0,n):
            v[:,h]=np.mean(lena11[j:,h+i][0:n])
        lena_new[j,i]=np.mean(v)
    
#plotting the picutre

import matplotlib.pyplot as plt
plt.imshow(lena_new, cmap=plt.cm.gray)
plt.show() 


###
#
# had to convert to grayscale:
# img = Image.open('/Users/akanwar/Documents/Image Processing course/assignments/flowers.jpg').convert('LA')
# img.save('greyscale.png')
#
# Y' = 0.299 R + 0.587 G + 0.114 B  (see wikipedai "grayscale")
# import numpy as np
# import matplotlib.pyplot as plt
# import matplotlib.image as mpimg

# def rgb2gray(rgb):
#     return np.dot(rgb[...,:3], [0.299, 0.587, 0.144])

# img = mpimg.imread('image.png')     
# gray = rgb2gray(img)    
# plt.imshow(gray, cmap = plt.get_cmap('gray'))
# plt.show()

# Example of np.r_ (Translates slice objects to concatenation along the first axis.)
#>>> np.r_[np.array([1,2,3]), 0, 0, np.array([4,5,6])]
#array([1, 2, 3, 0, 0, 4, 5, 6])
#>>> np.r_[-1:1:6j, [0]*3, 5, 6]
#array([-1. , -0.6, -0.2,  0.2,  0.6,  1. ,  0. ,  0. ,  0. ,  5. ,  6. ])

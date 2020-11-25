import cv2
import numpy as np
from exceptions import InvalidRequest

def resize_image(img):
    dim = (256, 256)
    return cv2.resize(img, dim, interpolation = cv2.INTER_AREA)


def segment_image(image, size):
    img_height = image.shape[0]
    img_width = image.shape[1]

    if img_height%size!=0 or img_width%size!=0:
        raise InvalidRequest('Image dimensions don\'t divide by block size')
    
    heigth_blocks = img_height//size
    width_blocks = img_width//size

    response = []
    for i in range(0,heigth_blocks):
        response.append([])
    
    for i in range(0,heigth_blocks):
        for j in range(0, width_blocks):
            x = i*size
            y = j*size
            x1 = x+size
            y1 = y+size
            rectangle = image[x:x1,y:y1]

            response[i].append(rectangle)

    return (heigth_blocks, width_blocks), response


def reconstruct_image(image_segments, shape, size):
    pass

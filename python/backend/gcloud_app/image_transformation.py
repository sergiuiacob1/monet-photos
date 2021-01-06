import cv2
from backend.gcloud_app.exceptions.invalid_request import InvalidRequest
import numpy as np


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
        for j in range(0, width_blocks):
            x = i*size
            y = j*size
            x1 = x+size
            y1 = y+size
            rectangle = image[y:y1,x:x1]

            response.append(rectangle)

    return (heigth_blocks, width_blocks), response


def reconstruct_image(image_segments, shape):
    lines, cols = shape
    if len(image_segments) != lines * cols:
        return []

    constructed_lines = []

    for line in range(lines):
        start_index = line * cols
        end_index = (line + 1) * cols
        current_images = np.array(image_segments[start_index:end_index])
        current_line = np.concatenate(current_images, axis=1)
        constructed_lines.append(current_line)

    constructed_lines = np.array(constructed_lines)

    return np.concatenate(constructed_lines, axis=0)

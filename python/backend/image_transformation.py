import cv2


def resize_image(img):
    dim = (256, 256)
    return cv2.resize(img, dim, interpolation = cv2.INTER_AREA)


def segment_image(image, size):
    return 1, []


def reconstruct_image(image_segments, shape, size):
    return []

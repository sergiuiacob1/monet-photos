from backend.gcloud_app.image_transformation import *
from cv2 import cv2


class ImageAdapter:
    def image_to_array(self, image):
        # returns the image as numpy array so that it can be fed as an input for the neural network
        image = resize_image(image)
        return image

    def array_to_image(self, array):
        # takes the numpy array returned by the generator and constructs an image based on image_format (PNG, JPEG etc.)
        return cv2.cvtColor(array, cv2.COLOR_GRAY2BGR)

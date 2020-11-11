from image_transformation import *


class ImageAdapter:
    def image_to_array(self, image):
        # returns the image as numpy array so that it can be fed as an input for the neural network
        image = resize_image(image)
        return image

    def array_to_image(self, array, image_format):
        # takes the numpy array returned by the generator and constructs an image based on image_format (PNG, JPEG etc.)
        pass

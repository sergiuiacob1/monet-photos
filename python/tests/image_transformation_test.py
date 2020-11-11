import numpy as np
from tests.test_utils import *
from image_transformation import *
from image_adapter import ImageAdapter


def test_image_resize():
    img = load_image("./tests/test_img.jpg")
    width, height = img.shape
    assert width != 256
    assert height != 256

    resized_img = resize_image(img)
    resized_width, resized_height = resized_img.shape

    assert resized_width == 256
    assert resized_height == 256


def test_image_to_array():
    img = load_image("./tests/test_img.jpg")
    image_adapter = ImageAdapter()
    network_input = image_adapter.image_to_array(img)

    assert isinstance(network_input, np.ndarray) is True
    assert network_input.shape == (256, 256, 3)


def test_array_to_image():
    network_output = np.random.rand(256, 256, 3)
    image_adapter = ImageAdapter()

    image = image_adapter.array_to_image(network_output, "jpg")

    assert image.shape[:2] == (256, 256)

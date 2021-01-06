import numpy as np
from testing.tests.test_utils import *
from backend.gcloud_app.image_adapter import ImageAdapter
from backend.gcloud_app.image_transformation import resize_image, segment_image, reconstruct_image
from backend.gcloud_app.style_transfer.monet_style_transfer import MonetStyleTransfer


def test_image_resize():
    img = load_image("testing/tests/test_img.jpg")
    width, height, _ = img.shape
    assert width != 256
    assert height != 256

    resized_img = resize_image(img)
    resized_width, resized_height, _ = resized_img.shape

    assert resized_width == 256
    assert resized_height == 256


def test_image_to_array():
    img = load_image("testing/tests/test_img.jpg")
    image_adapter = ImageAdapter()
    network_input = image_adapter.image_to_array(img)

    assert isinstance(network_input, np.ndarray) is True
    assert network_input.shape == (256, 256, 3)


def test_style_transfer():
    input_image = np.random.rand(256, 256, 3)
    transformer = MonetStyleTransfer()
    transformed = transformer.apply(input_image)
    assert np.any(input_image != transformed)


def test_segment_image():
    img = load_image("testing/tests/test_img_2.jpg")
    size = 256
    segment_block_shape, segments = segment_image(img, size)

    assert segment_block_shape == (2, 7)


def test_reconstruct_image():
    img = load_image("testing/tests/test_img_2.jpg")
    size = 256
    segment_block_shape, segments = segment_image(img, size)
    reconstructed_img = reconstruct_image(segments, segment_block_shape)

    assert np.array_equal(img, reconstructed_img)

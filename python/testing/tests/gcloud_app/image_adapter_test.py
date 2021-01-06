from training.image_adapter import ImageAdapter
import numpy as np


def test_normalisation():
    denormalised = np.random.randint(255, size=(256, 256, 3))
    normalised = ImageAdapter.to_network_input(denormalised)
    assert all(-1 <= x <= 1 for x in normalised.flatten())


def test_denormalisation():
    normalised = np.random.uniform(-1, 1, size=(256, 256, 3))
    denormalised = ImageAdapter.to_image(normalised)
    assert all(0 <= x <= 255 for x in denormalised.flatten())

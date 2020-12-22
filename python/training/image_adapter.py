class ImageAdapter:
    @staticmethod
    def to_network_input(dataset):
        return (dataset - 127.5) / 127.5

    @staticmethod
    def to_image(normalized_images):
        images = normalized_images * 127.5 + 127.5
        return images.astype(int)

from backend.gcloud_app.style_transfer.style_transfer_interface import StyleTransferInterface
import backend.gcloud_app.image_transformation as img_transform
import numpy as np


class MonetStyleTransfer(StyleTransferInterface):

    neural_network = {}
    size = 256

    def apply(self, image):
        shape, image_segments = img_transform.segment_image(image, self.size)
        generated_image_segments = []

        for segment in image_segments:
            # TO-DO: replace mock call with network forward pass
            generated_image = self.mock_apply_style(segment)
            generated_image_segments.append(generated_image)

        result = img_transform.reconstruct_image(generated_image_segments, shape)

        return result

    def load_model(self, path):
        pass

    def mock_apply_style(self, image):
        image = np.copy(image)
        print(image.shape)
        lin, col, _ = image.shape

        for i in range(lin):
            for j in range(col):
                r = image[i][j][2]
                image[i][j] = [r, r, r]

        return image


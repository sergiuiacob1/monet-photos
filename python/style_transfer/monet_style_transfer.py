from style_transfer.style_transfer_factory import StyleTransferFactory


class MonetStyleTransfer(StyleTransferFactory):

    neural_network = {}

    def apply(self, image):
        return image

    def train(self, data_set):
        pass

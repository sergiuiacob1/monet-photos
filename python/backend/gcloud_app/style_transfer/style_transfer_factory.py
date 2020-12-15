from backend.gcloud_app.style_transfer.monet_style_transfer import MonetStyleTransfer
from backend.gcloud_app.exceptions.invalid_request import InvalidRequest


class StyleTransferFactory:
    @staticmethod
    def provide_instance(style_name):
        if style_name == "monet":
            return MonetStyleTransfer()

        raise InvalidRequest("There is no style transfer with name: " + style_name)
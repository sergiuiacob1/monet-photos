from backend.requests.request_handler import RequestHandler
from backend.style_transfer.style_transfer_factory import StyleTransferFactory
from backend.requests.request_response import RequestResponse

from backend.exceptions.exceptions import InvalidRequest


class StyleTransferRequestHandler(RequestHandler):
    def handle(self, request):
        try:
            image = request.body
            style_name = request.query_params["style_name"]
            style_transfer_instance = StyleTransferFactory.provide_instance(style_name)
            transformed_image = style_transfer_instance.apply(image)
            return RequestResponse(200, transformed_image)
        except InvalidRequest as e:
            return RequestResponse(400, str(e))
        except Exception as e:
            return RequestResponse(500, e)

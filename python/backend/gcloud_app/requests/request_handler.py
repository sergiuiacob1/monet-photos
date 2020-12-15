from cv2 import cv2
from backend.gcloud_app.image_adapter import ImageAdapter

class RequestHandler:
    def __init__(self):
        self.image_adapter=ImageAdapter()

    def handle(self, request):
        uploaded_file = request.files['file']
        style = request.json['style']
        extension = request.json['filename']

        image = self.image_adapter.image_to_array(cv2.imdecode(uploaded_file.read()))
        # ML
        return self.image_adapter.array_to_image(cv2.imencode(extension,image))
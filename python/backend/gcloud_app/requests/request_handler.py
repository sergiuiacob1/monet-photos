from cv2 import cv2
from image_adapter import ImageAdapter
import keras
import numpy as np
import logging

class RequestHandler:
    def __init__(self):
        self.image_adapter=ImageAdapter()

    def handle(self, request, model):
        uploaded_file = request.files['file']
        style = request.form['style']
        extension = request.form['extension']

        logging.error(f"Params are: style={style}, extension={extension}")
        
        nparr = np.fromstring(uploaded_file.read(), np.uint8)

        logging.error("Transformed the image to nparray")
        
        image = self.image_adapter.image_to_array(cv2.imdecode(nparr,-1))
        image = self.image_adapter.to_network_input(image)
        reshaped_image = np.array(image).reshape(1,256,256,3)

        predicted_image = self.image_adapter.to_image(model.predict(reshaped_image))

        logging.error("Prediction successful!")

        return self.image_adapter.array_to_image(predicted_image[0], extension)
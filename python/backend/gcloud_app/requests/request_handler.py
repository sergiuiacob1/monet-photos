from cv2 import cv2
from image_adapter import ImageAdapter
import tensorflow_addons as tfa
import keras
import numpy as np

class RequestHandler:
    def __init__(self):
        self.image_adapter=ImageAdapter()

    def handle(self, request):
        uploaded_file = request.files['file']
        style = request.form['style']
        extension = request.form['extension']
        
        nparr = np.fromstring(uploaded_file.read(), np.uint8)
        image = self.image_adapter.image_to_array(cv2.imdecode(nparr,-1))
        
        reshaped_image = np.array(image).reshape(1,256,256,3)
        path = f"./generated_models/model.hdf5"
        model = keras.models.load_model(path, custom_objects={'InstanceNormalization':tfa.layers.InstanceNormalization})
        predicted_image = ((model.predict(reshaped_image) + 1) * 127.5).astype('int')

        print(predicted_image[0].shape)

        return self.image_adapter.array_to_image(predicted_image[0], extension)
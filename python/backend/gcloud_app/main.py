# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# [START gae_python38_app]
from flask import Flask, render_template, request, redirect, url_for
from requests.request_handler import RequestHandler
import keras
import numpy as np
import logging

# If `entrypoint` is not defined in app.yaml, App Engine will look for an app
# called `app` in `main.py`.
app = Flask(__name__)
request_handler = RequestHandler()
logging.error("Loading model...")
path = f"./generated_models/g_model_AtoB.h5"
model = keras.models.load_model(path)
logging.error("Model loaded...")
        

@app.route('/', methods=['POST'])
def upload_file():
    logging.error("Received request...")
    return request_handler.handle(request, model)


if __name__ == '__main__':
    # This is used when running locally only. When deploying to Google App
    # Engine, a webserver process such as Gunicorn will serve the app. This
    # can be configured by adding an `entrypoint` to app.yaml.
    app.run(host='127.0.0.1', port=8080, debug=True)
    logging.error("App started...")
# [END gae_python38_app]

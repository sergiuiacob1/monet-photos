class RequestResponse:
    status_code = 0
    content = ""

    def __init__(self, status_code, content):
        self.status_code = status_code
        self.content = content



import json
from http.server import BaseHTTPRequestHandler, HTTPServer


def f1(arguments):
    total = arguments["a"] + arguments["b"]
    return total
 

class testHTTPServer_RequestHandler(BaseHTTPRequestHandler):
  def do_POST(self):
        length = int(self.headers.get('content-length'))
        data = self.rfile.read(length)

        request = json.loads(data)

        if request.get('Request') == 'AreYouStarted':
            result = 'True'

        elif request['Function'] == '1':
            result = f1(request['Arguments'])

        result = json.dumps({
            "AllCorrect": "True",
            "Response": result
            })

        self.send_response(200)
 
        self.send_header('Content-type','application/javascript;charset=utf-8')
        self.end_headers()
 
        self.wfile.write(bytes(result, "utf8"))


def server(port):
    server_address = ('127.0.0.1', int(port))
    # print('running server on address', server_address)
    httpd = HTTPServer(server_address, testHTTPServer_RequestHandler)
    # print('running server...')
    httpd.serve_forever()
 

def run():
    import threading
    import sys

    # print("args--", sys.argv[1])

    thread = threading.Thread(target=server, args=[sys.argv[1]])
    thread.daemon = True
    thread.start()

    for line in sys.stdin:
        print(line)

run()

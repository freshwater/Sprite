
import json
from http.server import BaseHTTPRequestHandler, HTTPServer

"""
<python>
    total = <erlang>random:uniform(5)</erlang> + <erlang>random:uniform(5)</erlang>
    <erlang>Out1 = <python>total</python><erlang>
    total
</python>
"""

"""
<python>
    for i in range(500):
        <erlang>R = random:uniform(5)</erlang>
        print(<erlang>R</erlang>)
</python>
"""

"""
<erlang>
    sprite_execute(xk, [
        fun () -> R = random:uniform(5) end,
        fun () -> R end
        ]).
</erlang>
"""

"""
<python>
    for i in range(500):
        <erlang>R = random:uniform(5),
            <python>print("s: [" + str(i) + ", " + str(<erlang>R</erlang>) + "]")</python>
        <erlang>
</python>
"""

"""
<erlang>
    sprite_execute(xk, [
        fun() ->
            R = random:uniform(5),
            sprite_execute(zk, [ fun() -> R end ])
        end
    ])
</erlang>
"""

"""
<erlang>
    sprite_execute("s5375",
        [fun () -> random:uniform(5) end,
         fun () -> random:uniform(5) end,
         fun () -> Out1 = sprite_execute("s10502")])

    sprite_execute("s5375",
        [random:uniform(5),
         random:uniform(5),
         Out1 = sprite_execute("s10502")])
</erlang>
"""

def sprite_get(site_id):
    s = json_query()
    return s

def f1(arguments):
    total = sprite_execute("s157377", []) + sprite_execute("s5735737", [])
    sprite_execute("s1753753", [total])
    sprite_execute("s53737", [total])
 

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


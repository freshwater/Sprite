
import json
import os
import struct

import sys
import subprocess

def uuid_make():
    return str(struct.unpack("!Q", os.urandom(8))[0])

def main():
    print("COMPILING", sys.argv[1])

    if not os.path.exists("/workfolder/build"):
        os.makedirs("/workfolder/build")

    s = subprocess.Popen(["node", "SpriteParse.js", sys.argv[1]], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    fi = s.stdout.read()

    err = s.stderr.read()
    if err != b'':
        print("erro", err.decode('utf-8'))
        print("nu", fi)
        exit(zero)

    with open('/workfolder/build/structure.js', 'r') as f:
        text = f.read()
        print("SUR", text, "ound")
        structure = json.loads(text)

main()

# with open('template_dockerfile', 'r') as f:
#     template_dockerfile = f.read()
# 
# with open('/io/Dockerfile', 'w') as f:
#     f.write(template_dockerfile % {
#                 'dependencies': "",
#                 'file_names': file_names_copy,
#                 'entrypoint': entrypoint})
#


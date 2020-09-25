
import json
import os
import struct


def uuid_make():
    return str(struct.unpack("!Q", os.urandom(8))[0])


def gen_erlang(structure):
    out = []
    
    for block in structure:
        if isinstance(block, str):
            out.append(block)
        elif block[0] == 'python':
            pyin = []
            for b in block[2]:
                if isinstance(b, str):
                    pass
                elif b[0] == 'erlang' and isinstance(b[2][0], str):
                    pyin.append("\"" + b[1] + "\" => " + b[2][0])

            out.append("pyex(\"" + block[1] + "\", {" + ', '.join(pyin) + "})")
            
    return ''.join(out)


def gen_python(structure):
    out_all = {}
    
    for block in structure:
        if isinstance(block, str):
            pass
        elif block[0] == 'python':
            out = []
            site_id = block[1]
            out.append("def exo" + site_id + "(args" + site_id + "):\n")

            if len(block[2]) > 0:
                indent = None

                for b in block[2]:
                    if isinstance(b, str) and indent == None:
                        import re
                        match = re.match("(\s*\n)*", b)
                        b = b[len(match.group()):]

                        for i in range(len(b)):
                            if b[i] != " ":
                                indent = i
                                break

                        # out.append("    " + b[indent:])

                        newline_pos = b[:indent][::-1].find("\n") 
                        if newline_pos != -1:
                            indent = indent - newline_pos

                        b = ("\n" + b).replace("\n" + " "*indent, "\n" + "    ")

                        out.append(b)

                    elif isinstance(b, str):
                        b = b.replace("\n" + " "*indent, "\n" + "    ")
                        out.append(b)

                    elif b[0] == 'erlang' and isinstance(b[2][0], str):
                        out.append("args" + site_id + "[\"" + b[1] + "\"]")


            out_all[site_id] = ''.join(out)
            
    return out_all


visited_sites = set()
def is_new_site(site_id):
    if site_id in visited_sites:
        return False
    else:
        visited_sites.add(site_id)
        return True

site_data = {}
site_frame = {}

def site_frame_append(site_id, text):
    site_frame[site_id] = site_frame.get(site_id, '') + text

def site_append(site_id, text):
    site_data[site_id] = site_data.get(site_id, '') + text

def operate(structure):
    path = structure['Path']

    if path == ['erlang']:
        pass
    elif path == ['erlang', 'text']:
        # if is_new_site(structure['SiteId']):
        site_append(structure['PathIds'][0], structure['Children'])

    elif path == ['erlang', 'shell']:
        pass


def find_all(node, where, all=[]):
    if isinstance(node, dict):
        if where(node):
            all.append(node)

        for child in node.get('Children', []):
            find_all(child, where, all)

        return all

def file_type(structure, site_id):
    # nodes = find_all(structure, where=lambda x: False)
    # print("nodes", len(nodes))
    nodes = find_all(structure, where=lambda x: x['SiteId'] == site_id)
    # print("nodes", len(nodes))
    # print("nodes", [n['Path'] for n in nodes])
    # print("sorted", [n['Path'] for n in sorted(nodes, key=lambda x: len(x['Path']))])

    shortest = sorted(nodes, key=lambda x: len(x['Path']))[0]
    if shortest['Path'] in [['erlang']]:
        return 'erlang'

def has_prefix(main_list, prefix):
    return main_list[:len(prefix)] == prefix

def generate(structure):
    path = structure['Path']
    path_ids = structure['PathIds']
    children = structure['Children']

    if path == ['erlang']:
        for s in children:
            generate(s)

    elif path == ['erlang', 'text']:
        site_append(path_ids[0], children)

    elif path == ['erlang', 'bash', 'erlang']:
        return "X ".join([generate(s) for s in children])

    elif path == ['erlang', 'bash']:
        if is_new_site(path_ids[0]):
            site_frame_append(path_ids[0], "\n\nerlang_bash" + path_ids[0] + """(Args) ->
                ArgsBinary = lists:map(fun ([_|_] = L) -> list_to_binary(L);
                                           (S) when is_integer(S) -> integer_to_binary(S);
                                           (S) -> S end, Args),

                ArgsTogether = lists:foldr(fun (A, B) -> << A/binary, B/binary >> end, <<"">>, ArgsBinary),
                os:cmd(binary_to_list(ArgsTogether)).
            """)

            # args = find_all(structure, where=lambda x: x['Path'][-2:] == ['erlang', 'text'])
            # site_append(path_ids[1], "\n".join(["S" + s['SiteId'] + "=$" + str(i + 1)
                                                # for i, s in zip(range(len(args)), args)]))


        site_append(path_ids[0], "erlang_bash" + path_ids[0] + "([")
        args = find_all(structure, where=lambda x: x['Path'][-2:] == ['erlang', 'text'])
        site_append(path_ids[0], ", ".join([generate(s) for s in children if isinstance(generate(s), str)]))
        # site_append(path_ids[0], ", ".join([s['Children'] for s in args]))
        site_append(path_ids[0], "])")

    elif path == ['erlang', 'bash', 'text']:
        # site_append(path_ids[0], "\"" + children + "\"")
        return "<<\"" + children.replace("\"", "\\\"") + "\">>"

    elif path == ['erlang', 'bash', 'erlang', 'text']:
        return children
        # site_append(path_ids[0], children)

    elif path == ['erlang', 'python']:
        site_append(path_ids[0], "ERLANGPYTHON_PyFromErl( ")

        args = find_all(structure, where=lambda x: x['Path'][-2:] == ['erlang', 'text'])
        args = ["\"" + arg['SiteId'] + "\": " + arg['Children'] for arg in args]
        args = "{" + ", ".join(args) + "}"

        site_append(path_ids[0], args)
        site_append(path_ids[1], "def PyFromErl(args" + path_ids[1] + "):")
        for s in children:
            generate(s)
        site_append(path_ids[0], ")")

    elif path == ['erlang', 'python', 'text']:
        site_append(path_ids[1], children)

    elif path == ['erlang', 'python', 'bash']:
        site_append(path_ids[1], "PYTHONBASH(")
        for i, s in zip(range(len(children)), children):
            generate(s)
            if i < len(children) - 1:
                site_append(path_ids[1], ", ")

        site_append(path_ids[1], ")")

    elif path == ['erlang', 'python', 'bash', 'text']:
        site_append(path_ids[1], "\"" + children + "\"")

    elif path == ['erlang', 'python', 'bash', 'python']:
        for s in children:
            generate(s)
        # site_append(path_ids[1], children)
    elif path == ['erlang', 'python', 'bash', 'python', 'text']:
        site_append(path_ids[1], children)

    elif path == ['erlang', 'python', 'bash', 'erlang']:
        for s in children:
            generate(s)

    elif path == ['erlang', 'python', 'bash', 'erlang', 'text']:
        site_append(path_ids[1], "args" + path_ids[1] + "[\"" + path_ids[4] + "\"]")

    elif path == ['erlang', 'bash', 'Comment']:
        pass

    elif has_prefix(path, ['erlang', 'bash']):
        print(str(path) + ": not yet supported")
        process.zero(exit)
    else:
        # site_append(path_ids[0], "SITE_" + str(path))
        pass



def generate1(structure):
    new_structure = {}

    new_structure['Emit'] = operate(structure)

    if isinstance(structure.get('Children'), list):
        new_structure['Children'] = [generate(s) for s in structure['Children']]

    return new_structure


def generate0(structure):
    dependencies = None
    erlang = None
    pythons = {}
    
    for block in structure:
        if block[0] == 'dependencies':
            dependencies = ''.join(block[2])
        elif block[0] == 'erlang':
            erlang = {block[1]: gen_erlang(block[2])}
            python_dict = gen_python(block[2])
            for site_id, text in python_dict.items():
                pythons[site_id] = text
            
    return {'dependencies': dependencies,
            'erlang': erlang,
            'python': pythons}


import sys
import subprocess
print("COMPILING", sys.argv[1])

s = subprocess.Popen(["node", "test.js", sys.argv[1]], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
s.stdout.read()

err = s.stderr.read()
if err != b'':
    print("erro", err)
    exit(zero)

with open('/io/bin/structure.js', 'r') as f:
    text = f.read()
    print(text)
    structure = json.loads(text)


def frame(structure, path, pathIds):
    new_structure = {}

    if structure.get('Node') != None:
        node = structure['Node']
        site_id = uuid_make()

        new_structure['SiteId'] = site_id
        new_structure['Path'] = path + [node]
        new_structure['PathIds'] = pathIds + [site_id]

        if isinstance(structure['Children'], list):
            new_structure['Children'] = [
                    frame(s, path + [node], pathIds + [site_id])
                    for s in structure['Children']]
        else:
            new_structure['Children'] = structure['Children']

    return new_structure


def printJson(s):
    import subprocess

    js = json.dumps(s)
    with open('/io/bin/struct1.js', 'w') as f:
        f.write(js)

    s = subprocess.Popen(["node", "-p", "JSON.stringify(JSON.parse(require('fs').readFileSync('/io/bin/struct1.js')), null, 2)"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    print(s.stdout.read().decode())
    print(s.stderr.read().decode())


framed = frame([s for s in structure if s['Node'] == 'erlang'][0], [], [])
print("-------------------------")
printJson(framed)
print("-------------------------")

print("V------------------------")
gen = generate(framed)
printJson(gen)
print("^------------------------")

print("V-------site_data--------")
for site, content in site_data.items():
    print(site + ":")
    print(site_frame.get(site))
    print(content)
# printJson(site_data)
print("^------------------------")


file_names_copy = ""
for site, content in site_data.items():
    file_names_copy += '\nCOPY /bin/' + site + ' .'
    with open('/io/bin/' + site, 'w') as f:
        f.write(site_frame.get(site))
        f.write(content)

    if file_type(framed, site) == 'erlang':
        entrypoint = site

# dockerfile

with open('template_dockerfile', 'r') as f:
    template_dockerfile = f.read()

with open('/io/Dockerfile', 'w') as f:
    f.write(template_dockerfile % {
                'dependencies': "",
                'file_names': file_names_copy,
                'entrypoint': entrypoint})


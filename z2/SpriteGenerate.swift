
import Foundation

class Node : Decodable {
    let nodeType: String
    var children: [Node]!
    let text: String!

    let parent: Node!
    let siteId: String!
    var path: [(nodeType: String, siteId: String)]!

    enum CodingKeys : String, CodingKey {
        case nodeType = "NodeType"
        case children = "Children"
        case text = "Text"
        case parent = "ABCD1"
        case siteId = "ABCD2"
    }

    init(nodeType: String, text: String?, children: [Node], parent: Node?, siteId: String, path: [(nodeType: String, siteId: String)]!) {
        self.nodeType = nodeType
        self.text = text
        self.children = children
        self.parent = parent
        self.siteId = siteId
        self.path = path
    }

    func stringify(withIndent: String = "") -> String {
        let inner: String = text ?? (children! .map {$0.stringify(withIndent: withIndent + " ")}).joined(separator: "")

        let path: [String]! = []

        if text != nil {
            return inner.split(separator: "\n").joined(separator: "\n" + withIndent)
        } else {
            return withIndent + """
                   <\(nodeType) id="\(siteId ?? "")" parent="\(parent?.siteId ?? "")" path="\(path ?? [])">
                   \(inner)
                   </\(nodeType)>
                   """.split(separator: "\n").joined(separator: "\n" + withIndent)
        }

    }
}

func generate(node: Node, forTarget: String, topLevelSiteId: String?) -> String {

    print("X:\(node.siteId ?? "")")

    switch (forTarget, node.nodeType) {
        case ("erlang", "erlang"):
            let substrings = node.children .map { (child: Node) -> String in
                switch child.nodeType {
                    case "bash":
                        return generate(node: child, forTarget: forTarget, topLevelSiteId: topLevelSiteId)
                    
                    case "text":
                        return child.text ?? "0"

                    case "parameter":
                        return "erlang_parameter_get(\(child.text ?? ""))"

                    default:
                        assert(false, "\n\nheck:\(child.nodeType)\n\n")
                }
            }

            return "fun () -> \(substrings.joined(separator: "")) end"

        case ("erlang", "bash"):
            let substrings = node.children .filter { $0.nodeType == "erlang" } .map { (child: Node) -> String in
                "\"\(child.siteId!)\" => \(generate(node: child, forTarget: forTarget, topLevelSiteId: topLevelSiteId))"
            }

            let hashmap = "#{\(substrings.joined(separator: ", "))}"

            return "(bash_execute(\"\(node.siteId!)\", \(hashmap)))"

        case ("bash", "bash"):
            let substrings = node.children .map { (child: Node) -> String in
                switch child.nodeType {
                    case "erlang":
                        return generate(node: child,
                                        forTarget: forTarget,
                                        topLevelSiteId: topLevelSiteId ?? node.siteId!)

                    case "text":
                        return child.text ?? "0"

                    default:
                        assert(false, "\n\nhock\(child.nodeType)\n\n")
                }
            }

            let subids = node.children .map { child in
                return child.siteId!
            }

            let subqueries = node.children .map { child in
                return "$(bash_self_get\(child.siteId!)[\(child.text ?? "")])"
            }

            // is this the root node for the site
            if node.siteId == (topLevelSiteId ?? node.siteId) {
                return "\(substrings.joined(separator: "--"))\\B"
            } else {
                // return "sprite_self_get\(subids.joined(separator: ", "))\\B"
                return subqueries.joined(separator: ". ")
            }

        case ("bash", "erlang"):
            let substrings = node.children .compactMap { (child: Node) -> String? in
                switch child.nodeType {
                    case "bash":
                        return generate(node: child, forTarget: forTarget, topLevelSiteId: topLevelSiteId)

                    case "erlang":
                        return "T"

                    case "text":
                        return nil

                    case "parameter":
                        return "PARAM"

                    default:
                        assert(false, "K--\(child.nodeType)")
                        return "K"
                }
            }

            """
            fo () { case "$1" in "a") echo "A" ;; "b") echo "B" ;; esac }
            sprite_return_$GET
            """

            if topLevelSiteId == nil {
                return substrings.joined(separator: "")
            } else {
                if substrings.count > 0 {
                    return "$(call_extern \"\(node.siteId!)\" \(substrings.joined(separator: "_")))"
                } else {
                    return "$(call_extern \"\(node.siteId!)\")"
                }
            }

        case ("bash", _):
            let substrings = node.children .map { (child: Node) -> String in
                generate(node: child, forTarget: forTarget, topLevelSiteId: topLevelSiteId)
            }

            return substrings.joined(separator: "")

        case (_, "erlang"):
            let substrings = node.children .map { (child: Node) -> String in
                generate(node: child, forTarget: forTarget, topLevelSiteId: topLevelSiteId)
            }

            return substrings.joined(separator: "-X-")

        case (_, "bash"):
            return "<bi></bi>"

        case (_, "root"):
            let substrings = node.children .map { (child: Node) -> String in
                generate(node: child, forTarget: forTarget, topLevelSiteId: nil)
            }

            return substrings.joined(separator: "~x~")

        case (_, "text"):
            return node.text

        case (_, "dependencies"):
            return "<DEPS></DEPS>"
        
        case (_, "parameters"):
            return ""

        default:
            assert(false, "\n\n\(node.nodeType)\n\n")
            return "fu"
    }
}

func layout(node: Node, parent: Node?) -> Node {
    let siteId = "\(arc4random())"
    var new: Node!

    new = Node(nodeType: node.nodeType,
               text: node.text,
               children: [],
               parent: parent,
               siteId: siteId,
               path: (parent?.path ?? []) + [(nodeType: node.nodeType,
                                              siteId: siteId)])

    new.children = (node.children ?? []) .map { child in
        layout(node: child, parent: new)
    }

    return new
}

let jsonData = try! Data(contentsOf: URL(fileURLWithPath: "build/structure.js"))

let structure = try! JSONDecoder().decode(Node.self, from: jsonData)

let layedOut = layout(node: structure, parent: nil)
print(layedOut.stringify())

// print("--------------------")
// print("--------------------")
// print(try! String(contentsOf: URL(fileURLWithPath: "script.erl")))
// print("--------------------")
// print("erlang")
// print(generate(node: layedOut, forTarget: "erlang", topLevelSiteId: nil))
print("--------------------")
print("bash")
print(generate(node: layedOut, forTarget: "bash", topLevelSiteId: nil))



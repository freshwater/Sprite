

BlockSequence
    = (Block / Text / Comment)*

Block
    = open:TagOpen inner:(!TagClose sequence:BlockSequence { return sequence }) close:TagClose & { return open === close } {
        // return [open, "~[ ]~", inner]
        return {"Node": open, "Children": inner}
    }

Text
    = text:( !(TagOpen / TagClose / Comment) c:. { return c })+ { return {"Node": "text", "Children": text.join('')} }

TagOpen
    = '<' id:[a-z]+ '>' { return id.join('') }

TagClose
    = '</' id:[a-z]+ '>' { return id.join('') }

Comment
    = '<!--' text:(!'-->' c:. { return c})+ '-->' { return {"Node": "Comment", "Children": text.join('')} }


SPRITE_FIFO="s1573537"

function get {
    echo base64/$(echo GET[$1] | base64) > $SPRITE_FIFO
    cat $SPRITE_FIFO
}

function message {
    echo base64/$(echo MESSAGE[$1] | base64) > $SPRITE_FIFO
}

echo ASKING FOR ~~f I GOT $(get ~~f)

echo NEW ONE: $(get tehnewone)

message DONE

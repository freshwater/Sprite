
SPRITE_FIFO="s1573537"

THE_VAR=565

function self_get_scroop1 {
    printf "[thevar["$THE_VAR"]end]"
}

function sprite_get {
    printf base64/$(printf GET[$1] | base64) > $SPRITE_FIFO
    RESPONSE=$(cat $SPRITE_FIFO | base64 -D)

    if [[ $RESPONSE = "GET["* ]]; then
        # echo "got get-----" $(printf $RESPONSE | cut -b 5- | rev | cut -b 2- | rev)
        SPRITE_SITE=$(printf $RESPONSE | cut -b 5- | rev | cut -b 2- | rev)
        self_get_$SPRITE_SITE
    fi

    # $(cat $SPRITE_FIFO | base64 -D)
}

function sprite_done {
    echo base64/$(printf DONE[] | base64) > $SPRITE_FIFO
}

# ------

echo ~~f: $(sprite_get "~~f")
echo NEW ONE: $(sprite_get NEW_ONE)
echo $(sprite_get "helsinki")

# ------

sprite_done


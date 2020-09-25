
function s55 {
    echo ${S}$XYZ
}

echo 1
XYZ=55

let "S = $XYZ + 5"

s55


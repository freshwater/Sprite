
<python>
    <dependencies>
        RUN pip install boto3
    </dependencies>
</python>

<erlang>


stack_create(Variable) ->
    <python>
            print("HELLO" + <erlang>Variable ++ Variable</erlang>)

            if int(<bash>ls -al | wc -l</bash>) > 5:
               return False

            abc = 5
            print(•erlang•
                  Variable ++ <bash capturePython="abc">wc $abc</bash>
                           ++ <bash>wc <python>abc</python></bash>
                           ++ •bash•wc •python•abc•/python••/bash•
                           ++ <?bash wc <?python abc ?> ?>
                           ++ <?bash> wc <?python>abc</python?></bash?>
                           ++ 〈bash〉wc 〈python〉abc〈/python〉〈/bash〉
                           ++ ❬bash❭wc ❬python❭abc❬/python❭❬/bash❭
                           ++ ❮bash❯wc ❮python❯abc❮/python❯❮/bash❯
                           ++ ❰bash❱wc ❰python❱abc❰/python❱❰/bash❱
                           ++ 「bash」wc 「python」abc「/python」「/bash」
                           ++ ｢bash｣ wc ｢python｣abc｢/python｣｢/bash｣
                           ++ ⸦bash⸧wc ⸦python⸧abc⸦/python⸧⸦/bash⸧
                           ++ ⦑bash⦒wc ⦑python⦒abc⦑/python⦒⦑/bash⦒
                           ++ ᚜bash᚛wc ᚜python᚛abc᚜/python᚛᚜/bash᚛
                           ++ <?bash>wc <?python>abc</?python></?bash>
           •/erlang•)
    </python>.

system_copyo() ->
    <python>
                woot()
    </python>
    {}.

start(Args) ->
    <bash>ls -al</bash>,
    "ABC".

</erlang>


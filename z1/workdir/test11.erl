
<erlang>
    
system_copy() ->
    <bash>
        for i in 0..5 ; do <python>
            global i
            i = i or 0 + 1
            print(i)
        </python> done
    </bash>,

    S = 4,

    First = lists:nth(5, <python Buckets<=buckets>
        k = 77
        <!-- [<erlang>random:uniform(<python>k*<erlang>S</erlang></python>)</erlang> for _ in range(50)] -->
        for i in range(50):
            print(<erlang>random:uniform(<python>k*<erlang>S</erlang></python>)</erlang>)

            bucket("A", 5)
    </python>),

    <bash>
        <python Instance<=instance></python>

        for i in 0..5 ; do <python instance=Instance>
            global i
            i = i or 0 + 1
            print(i)
        </python> done
    </bash>,

    Origin = self(),

    <python Instance2<=instance>
        def send(message):
            <erlang>Origin ! <python>message</python></erlang>
    </python>,

    <python instance=Instance2>
        send("hello")
        send("there")
    </python>,

    receive
        Message ->
            io:format("Message: " ++ Message)
    end.

main(Args) ->
    system_copy().

</erlang>


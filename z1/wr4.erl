
%% ================

print(Args) ->
    io:format("~p~n", [Args]).

main(_Args) ->
    os:cmd("mkfifo s1573537"),

    Port = open_port({spawn, "./clipper.sh"}, [{line, 9999999999}, exit_status]),

    Interop = fun Continue() ->
        case file:read_file("s1573537") of
            {ok, <<"base64/", QueryBase64/binary>>} ->
                Query = base64:decode(QueryBase64),
                print({query, Query}),
                file:write_file("s1573537", <<"I see your ", Query/binary, "and give you zed">>),
                Continue();
            Else ->
                print({else, Else})
        end
    end,

    StdOut = fun Continue() ->
        receive
            {_Port, {exit_status, S}} ->
                print({ss, S}),
                ok;

            {_Port, {data, {_, Data}}} ->
                print({data, Data}),
                Port ! {self(), {command, "def\n"}},

                Continue()
        end
    end,

    spawn(Interop),

    StdOut(),

    os:cmd("rm s1573537"),

    print("done.").





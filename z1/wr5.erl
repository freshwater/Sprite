

print(Args) ->
    io:format("~p~n", [Args]).

main(_Args) ->

    % script interop
    Interop = fun Continue() ->
        case file:read_file("s1573537") of
            {ok, <<"base64/", QueryBase64/binary>>} ->
                QueryFull = base64:decode(QueryBase64),

                SiteLength = length(binary_to_list(QueryFull)) - length("GET[]"),

                case QueryFull of
                    <<"GET[", Site:SiteLength/binary, "]">> ->
                        print({"received site query", Site}),
                        file:write_file("s1573537", base64:encode(<<"GET[scroop1]">>)),
                        Continue();
                    <<"DONE[]">> ->
                        print("reached done"),
                        done;
                    Else ->
                        print({else, Else})
                end;
            Else ->
                print({else, Else})
        end
    end,

    % script stdout reader
    StdOut = fun Continue(Port, LinesAccumulated) ->
        receive
            {_Port, {exit_status, _Status}} ->
                LinesAccumulated;

            {_Port, {data, {_, Line}}} ->
                print({data, Line}),
                Port ! {self(), {command, "def\n"}},

                case LinesAccumulated of
                    "" ->
                        Continue(Port, Line);
                    _Else ->
                        Continue(Port, LinesAccumulated ++ "\n" ++ Line)
                end
        end
    end,

    % =====

    % create FIFO
    os:cmd("rm s1573537 ; mkfifo s1573537"),

    % connect to script
    Port = open_port({spawn, "./clipper2.sh"}, [{line, 9999999999}, exit_status]),

    spawn(Interop),

    Acc = StdOut(Port, []),

    os:cmd("rm s1573537"),

    print(""),
    print("stdout:"),
    print(Acc).



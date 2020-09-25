
file_fifo() ->
    "s1573537".

file_script() ->
    "./clipper2.sh".

print(Args) ->
    io:format("~p~n", [Args]).

main(_Args) ->

    FifoFile = filefifo(),
    ScriptFile = file_script(),

    ScriptInterop = fun Continue() ->
        case file:read_file(FifoFile) of
            {ok, <<"base64/", QueryBase64/binary>>} ->
                QueryFull = base64:decode(QueryBase64),

                SiteLength = length(binary_to_list(QueryFull)) - length("GET[]"),

                case QueryFull of
                    <<"GET[", Site:SiteLength/binary, "]">> ->
                        print({"ScriptRequestingSite:", Site}),
                        file:write_file(FifoFile, base64:encode(<<"GET[scroop1]">>)),
                        Continue();
                    <<"DONE[]">> ->
                        done;
                    Else ->
                        print({else, Else})
                end;
            Else ->
                print({else, Else})
        end
    end,

    StdOutRead = fun Continue(Port, LinesAccumulated) ->
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
    os:cmd("rm " ++ FifoFile ++ " ; mkfifo " ++ FifoFile),

    % connect to script
    Port = open_port({spawn, ScriptFile}, [{line, 9999999999}, exit_status]),

    spawn(ScriptInterop),

    StdOut = StdOutRead(Port, []),

    os:cmd("rm " ++ FifoFile),

    print(""),
    print("stdout:"),
    print(StdOut).


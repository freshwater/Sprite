
%% ================

-module(hello).
-export([start/2]).

print(Args) ->
    io:format("~p~n", [Args]).


start(Port, Respond) ->
    ContentLength = fun(Data) ->
        S = string:find(Data, "Content-Length: "),
        X = string:prefix(S, "Content-Length: "),
        {Y, _} = string:take(X, "0123456789"),
        list_to_integer(Y)
    end,

    spawn(fun () ->
              {ok, Socket} = gen_tcp:listen(Port, [{active, true}]), 
              {ok, Connection} = gen_tcp:accept(Socket),

              Data = receive
                  {tcp, _Port, Data1} ->
                      print({received, Data1}),
                      print("\n"),

                      TotalContentLength = ContentLength(Data1),

                      print({total_content_length, TotalContentLength}),

                      Single = fun() ->
                           lists:nthtail(length(Data1) - TotalContentLength, Data1)
                      end,

                      Multiple = fun Continue(LengthAccumulated, DataAccumulated) ->
                        receive
                            {tcp, _Port, Data2} ->
                                LAccumulated = LengthAccumulated + length(Data2),
                                DAccumulated = DataAccumulated ++ Data2,

                                case LAccumulated of
                                    TotalContentLength ->
                                        DAccumulated;
                                    _ ->
                                        Continue(LAccumulated, DAccumulated)
                                end;
                            _ ->
                                ok
                        end
                      end,

                      if
                          length(Data1) < 200 ->
                              case string:find(Data1, "Expect: 100-continue\r\n\r\n") of
                                  nomatch -> Single();
                                  _ ->
                                      Multiple(0, [])
                              end;
                          true ->
                              Single()
                      end;

                  Else ->
                      print({"ELSE", Else})
              end,

              print({the_data, Data}),

              gen_tcp:send(Connection, response(Respond(Data))), % response("echo ls -al -- " ++ Data)),
              gen_tcp:close(Socket),

              receive
                  _ -> ok
              end

              % fun () ->
              % gen_tcp:controlling_process(Connection, spawn(fun () ->
                                  % gen_tcp:send(Connection, response("echo ls -al -- " ++ Data)),
                                  % gen_tcp:close(Socket),
                                  % receive
                                      % _ -> ok
                                  % end
                              % end))
              % end
          end).


response(Str) ->
    B = iolist_to_binary(Str),
    iolist_to_binary(
      io_lib:fwrite(
         "HTTP/1.0 200 OK\nContent-Type: text/html\nContent-Length: ~p\n\n~s",
         [size(B), B])).

%% ================

respond(Data) ->
    print({"THE DATA!", Data}),
    "fruit loops".


main(_Args) ->
    case request_Erlang("ABC", ["ABC"]) of
        {value_and_request, Value, Request} ->
            io:fwrite(Value),
            Response = io:fread("s555-REQUEST-4574572", "~s"),
            respond ! Response,
            main([]);
        {value, Value} ->
            io:fwrite(Value)
    end.


main0(_Args) ->
    start(57589, fun (Data) ->
                   print({"THENUOTHEN", Data}),
                   "ls"
    end),

    S = lists:flatten(lists:map(fun (I) -> integer_to_list(I) end, lists:seq(1, 40))),
    Port = open_port({spawn,
        "$(curl -X POST --silent --show-error http://127.0.0.1:57589 -d '{\"SiteId\": \"s17537\", \"Data\": \"" ++ S ++ "\"}')"},
                     [{line, 9999999999999}, exit_status]),

    Receive = fun Continue() ->
        receive
            {_Port, {exit_status, _}} ->
                ok;
            {_Port, {data, {_, Data}}} ->
                print(Data),
                Continue()
        end
    end,

    Receive(),

    print("done.").






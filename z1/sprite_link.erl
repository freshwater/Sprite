
-module(sprite_link).

-export([start_python/0, execute_python/2]).

execute_bash(Script, Options) ->
    Port = open_port({spawn, Script}, []).

start_python() ->
    HttpPortInt = rand:uniform(round(math:pow(2, 16))),
    HttpPort = integer_to_list(HttpPortInt),

    Port = open_port({spawn, "python3.8 -u template_python.py "
                             ++ HttpPort
                             ++ " -m http.server"}, []),

    Check = fun Check(0) -> error; 
                Check(N) ->
        Response =
            httpc:request(post,
                          {"http://127.0.0.1:" ++ HttpPort, [], "application/javascript",
                           jsone:encode(#{
                             <<"Request">> => <<"AreYouStarted">>
                            })},
                          [], []),

         case Response of 
             {ok, {_, _, Body}} ->
                 case jsone:decode(list_to_binary(Body)) of
                     #{<<"AllCorrect">> := <<"True">>,
                       <<"Response">> := <<"True">>} ->
                         % io:format("non-message-ok [~p~n]", [N]),
                         ok;
                     _S ->
                         % io:format("\nmessage: ~p~n", [S]),
                         Check(N - 1)
                 end;
             _S ->
                 % io:format("\n\nfailure: ~p~n\n\n", [_S]),
                 timer:sleep(17),
                 Check(N - 1)
         end
    end,

    ok = Check(20),

    Interface = fun Interface() ->
        receive
            {From, execute, {SiteId, Arguments}} ->
                Response3 = httpc:request(post,
                                  {"http://127.0.0.1:" ++ HttpPort, [], "application/javascript",
                                   jsone:encode(#{
                                     <<"Function">> => SiteId,
                                     <<"Arguments">> => Arguments
                                    })},
                                  [], []),

                case Response3 of
                    {ok, {_, _, Body}} ->
                        case jsone:decode(list_to_binary(Body)) of
                            #{<<"AllCorrect">> := <<"True">>,
                              <<"Response">> := Response} ->
                                From ! {ok, Response},
                                Interface();
                            S ->
                                From ! {errorx, S}
                        end;
                    S ->
                        From ! {errory, S}
                end;

            {_, stop} ->
                % io:format("Else: ~p~n", [Else]),
                port_close(Port)
        end
    end,

    spawn(Interface).


execute_python(_SiteId, _Arguments) ->
    SiteId = <<"1">>,
    Arguments = #{<<"a">> => 1, <<"b">> => -4},

    Interface = start_python(),

    Interface ! {self(), execute, {SiteId, Arguments}},

    Result = receive
        {ok, Result1} ->
            Result1;
        S ->
            io:format("S: ~p~n", [S])
    end,

    Interface ! {self(), stop},

    Result.


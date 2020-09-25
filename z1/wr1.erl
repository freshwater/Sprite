
print(Args) ->
    io:format("~p~n", [Args]).

% 
% <l1>
% system_copy(A) ->
%   S = 5,
%   print(A + <l2>random:uniform(<l1>S</l1>)</l2>).
% </l1>
%

system_copy(A) ->
    S = 5,
    print(A + site5(#{s3573 => fun () -> S end})).
            
site5(Args) ->
    rand:uniform((maps:get(s3573, Args))()).

% 
% <l1>
% system_copy(A) ->
%   S = 5,
%   print(A + <bash>curl <l1>S</l1></bash>).
% </l1>
%

% <bash>
%     sprite_evaluate () {
%         
%     }
% </bash>

sprite_link_bash(InstanceId) ->
    % global_sprite_evaluate () {
    %   SITE_ID=$0
    %   curl -X POST http://127.0.0.1:57544/ -d $hash1
    % }

    5.


site6(Args) ->
    bord_create.

system_copy2(A) ->
    S = 5,
    print(A + site6(#{s3573 => fun () -> S end})).
            

main(_Args) ->
    print("\n\n"),

    system_copy(6),

    print("\n\n").

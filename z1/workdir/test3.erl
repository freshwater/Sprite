
<erlang>

system_copy(NewStackName, SourceStackName, Opts) ->
    Bash = <bash echo="True">
        NEW_STACK_NAME=<erlang>NewStackName</erlang>
        SOURCE_STACK_NAME=<erlang>SourceStackName</erlang>

        <!-- echo <python>"ls" + " " + "-al"</python> -->
        echo <!--javascript>console.warn("test")</javascript-->

        echo the pwd
        echo $(pwd)
        echo /the pwd

        touch fruitloops
        touch <erlang>NewStackName ++ SourceStackName</erlang>
        touch fruitloopsy

        echo $NEW_STACK_NAME $SOURCE_STACK_NAME
    </bash>,

    Python = <python><erlang>SourceStackName</erlang>[:5]</python>,

    {Bash, Python}.

main(Args) ->
    Bash = <bash>ls -al</bash>,
    io:format(Bash),

    SystemCopy = system_copy("ABC", "DEF", #{}),

    io:format("\n\n"),

    io:format(SystemCopy).

</erlang>


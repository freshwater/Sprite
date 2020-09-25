
<dependencies>
    RUN apt-get install curl
</dependencies>

<parameters>
    <parameter>StackName</parameter>
    <parameter>Credentials</parameter>
</parameters>

<erlang>

main(Args) ->
    Z1 = "s",
    Z2 = <<"echo">>,
    Z3 = <<"The Last Number">>,

    Out = <bash>for i in 1 2 3 4 <erlang>Z3</erlang>; do
            echo <erlang><<<bash>$i</bash>/binary, Z2/binary>></erlang>
          done</bash>

    print({out, Out, <parameter>Credentials</parameter>}).

</erlang>


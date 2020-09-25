
<dependencies>
    RUN \
      echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
      add-apt-repository -y ppa:webupd8team/java && \
      apt-get update && \
      apt-get install -y oracle-java8-installer && \
      rm -rf /var/lib/apt/lists/* && \
      rm -rf /var/cache/oracle-jdk8-installer
</dependencies>

<erlang>

test(A, B, C) ->
    <java>
        <imports>
            import hakuna.matata.*;
        </imports>

        public static String main(String[] args) {
            String a = String.valueOf(<erlang>A + B</erlang>);
            return a.length();
        }
    </java>.

main(Args) ->
    Result = test(1, 2, <<"ls">>),
    io:format("~p~n", Result).

</erlang>


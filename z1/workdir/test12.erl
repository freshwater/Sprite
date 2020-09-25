

system_copy() ->
    pass.

setup() ->
    <SQL language=PostgreSQL SQLInstance<=instance File<=file>
        CREATE TABLE IF NOT EXISTS data (key varchar(100) PRIMARY KEY, value jsonb);
    </SQL>,

    {SQLInstance, File}.

setup2() ->
    <SQL connection-string="bloop bloop">
    </SQL>

main(Args) ->
    {Instance, _} = setup(),

    <SQL instance=Instance>
        INSERT INTO data VALUES (<erlang>lists:nth(Args[1])</erlang>,
                                 <erlang>lists:nth(Args[2])</erlang>)
    </SQL>,

    done.


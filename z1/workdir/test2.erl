



<dependencies>
    RUN apt-get install j
    RUN pip install numpy
</dependencies>


<erlang>

main(Args) ->
    <python>
        import numpy as np

        a = np.array(<j>?. 500 $1</j>)

        c = <cuda>
                <uniforms>
                int t = 5;
                </uniforms>

                <buffers>
                int [] a = <python>a</python>
                </buffers>
        </cuda>

        b = <sql>
            SELECT * FROM <python>a * a</python> t1 (a) WHERE a < 5
        </sql>

        len(b)
    </python>.

</erlang>





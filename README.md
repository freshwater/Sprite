












Sprite is an idea I've had for 6.7 million years + 35 seconds. There are two components to the idea. First, it is a polyglot language. The idea is that you can intermix languages in arbitrary configurations:

    <erlang>
        main() ->
            Urls = <postgresl> SELECT url FROM interesting_table </postgresql>,

            Htmls = <python>
                [<bash> curl <python>url</python> </bash> for url, in <erlang>Urls</erlang>]
            </python>,

            Htmls.
    </erlang>


This isn't super valuable on its own, since there are implicit switching costs to having a bunch of languages in the same logic in terms of understandability. The second component is the utility, which is not as obvious, but basically this language is meant to easily scale in terms of complexity.

Imagine you write a shell script to quickly perform task X. It's useful enough that you start adding features to the script, so it grows. Then team members start asking you to add features. So it grows. And grows. At some point it aquires enough importance that you have in the extreme case two choices. You either replace it with an entirely new script in a new language, or you stick with it because of the edge cases that it already properly handles and the expectation of a high refactoring cost and accept the complexity of dealing with it.

The idea with Sprite is that you can keep your script. You just change its extension to .sprite and wrap it like so:

    <erlang>
        <bash>
            <!-- your script here -->
        </bash>
    </erlang>

And you are good to go. You can start excavating, replacing, surgerizing sections ad hoc. If there is a section that requires high performance, just wrap it in `<java> </java>` or `<c> </c>`.

So the main idea with Sprite is refactoring liquidity. As part of this philosophy, one of the ideas is that the outer level is always Erlang. This provides enough guardrails to minimize cross-cutting state between components and to make it easy enough to networkize things when necessary.

These are my current thoughts on the idea. It's currently in "does not even exist" mode as I'm exploring different routes to implement the proof of concept. This is an experimental smorgasboard[sic] for the time being.




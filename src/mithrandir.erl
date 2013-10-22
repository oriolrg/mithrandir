-module(mithrandir).

-export([start/0]).

start() ->
    ensure_started(ibrowse),
    ensure_started(sasl),
    ensure_started(couchbeam).


%% internal
ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.

-module(mithrandir).
-export([start/0]).

start() ->
    %% starting couchbeam app
    ensure_started(crypto),
    ensure_started(public_key),
    ensure_started(ssl),
    ensure_started(ibrowse),
    ensure_started(asn1),
    ensure_started(sasl),
    ensure_started(couchbeam),

    ensure_started(mithrandir).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.

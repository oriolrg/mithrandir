-module(mithrandir_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

routes() ->
    [
     {'_', [
            {"/[...]", cowboy_static, [
                                       {directory, {priv_dir, mithrandir, [<<"www">>]}},
                                       {file, "index.html"},
                                       {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
                                      ]}
           ]}
    ].

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile(routes()),
    {ok, _} = cowboy:start_http(http, 100, [{port, 8080}], [
                                                            {env, [{dispatch, Dispatch}]}
                                                           ]),
    mithrandir_sup:start_link().

stop(_State) ->
    ok.

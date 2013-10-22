-module(mcouch).
-behaviour(gen_server).

%% gen_server
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([terminate/2]).
-export([code_change/3]).

-export([start_link/0]).
-export([start_link/1]).
-export([upgrade/0]).

-include_lib("couchbeam/include/couchbeam.hrl").

-type oauth() ::
        {consumer_key, string()} | {token, string()} | {token_secret, string()} |
        {consumer_secret, string()} | {signature_method, string()}.

-type oauthOptions() :: [oauth()].

-type option() ::
        {is_ssl, boolean()} |
        {ssl_options, [term()]} |
        {pool_name, atom()} |
        {proxy_host, string()} |
        {proxy_port, integer()} |
        {proxy_user, string()} |
        {proxy_password, string()} |
        {basic_auth, {string(), string()}} |
        {cookie, string()} |
        {oauth, oauthOptions()}.

-type host() :: string().
-type port_num() :: integer().
-type prefix() :: string().
-type options() :: [option()].


-spec start_link() -> {ok, pid()} | {error, any()}.
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

-spec start_link({host(), port_num(), prefix(), options()}) ->
                        {ok, pid()} | {error, any()}.
start_link(Conn) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, Conn, []).


%% gen_server
init([]) ->
    State = couchbeam:server_connection(),
    {ok, State};
init({Host, Port, Prefix, Options}) ->
    State = couchbeam:server_connection(Host, Port, Prefix, Options),
    {ok, State}.

handle_call(state, _From, State) ->
    {reply, State, State};
handle_call(terminate, _From, State) ->
    {stop, normal, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% don't try it at home
upgrade() ->
    {ok, Vsn} = application:get_key(?MODULE, vsn),
    sys:suspend(?MODULE),
    code:purge(?MODULE),
    code:load_file(?MODULE),
    sys:change_code(?MODULE, ?MODULE, Vsn, []),
    sys:resume(?MODULE).

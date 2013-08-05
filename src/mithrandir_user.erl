-module(mithrandir_user).

-export([create/4]).
-export([exists/1]).
-export([delete/1]).

%% @doc create an user
%% Consumer must contain consumer keys
%% @spec create(Username::bitstring(), Consumer::list(), AccessToken::bitstring(),
%%              AccessTokenSecret::bitstring()) -> {ok, bitstring()}
create(Username, Consumer, AccessToken, AccessTokenSecret) ->
    Postfix = list_to_binary(string:to_lower(binary_to_list(AccessTokenSecret))),
    DbName = <<Username/binary, <<"-">>/binary, Postfix/binary>>,
    {ok, Db} = mithrandir_couch:db(DbName),
    Doc = {[
            {<<"_id">>, <<"user">>},
            {<<"username">>, Username},
            {<<"consumer">>, Consumer},
            {<<"accesstoken">>, AccessToken},
            {<<"accesstokensecret">>, AccessTokenSecret}
           ]},
    {ok, _} = mithrandir_couch:save_doc(Db, Doc),
    {ok, DbName}.

%% @doc check if an user exists
%% @spec exists(Userid::bitstring()) -> boolean()
exists(UserId) ->
    mithrandir_couch:db_exists(UserId).

%% @doc delete an user
%% @spec delete(UserId::bitstring()) -> {ok, tuple()} | {error, tuple()}
delete(UserId) ->
    mithrandir_couch:delete_db(UserId).

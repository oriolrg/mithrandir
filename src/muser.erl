-module(muser).

-export([create/1]).
-export([exists/1]).
-export([delete/1]).

-include("mithrandir.hrl").


%% @doc create an user
-spec create(user()) -> {ok, binary()} | {error, any()}.
create(User) ->
    DbName = User#user.username,
    {ok, Db} = mcouch:db(DbName),
    Doc = {[
            {<<"_id">>, <<"user">>},
            {<<"username">>, User#user.username},
            {<<"consumer_key">>, User#user.consumer_key},
            {<<"consumer_secret_key">>, User#user.consumer_secret_key},
            {<<"accesstoken_key">>, User#user.accesstoken_key},
            {<<"accesstoken_secret_key">>, User#user.accesstoken_secret_key}
           ]},
    {ok, _} = mcouch:save_doc(Db, Doc),
    {ok, DbName}.

%% @doc check if an user exists
-spec exists(binary()) -> boolean().
exists(UserId) ->
    mcouch:db_exists(UserId).

%% @doc delete an user
-spec delete(binary()) -> {ok, term()} | {error, term()}.
delete(UserId) ->
    mcouch:delete_db(UserId).

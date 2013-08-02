-module(mithrandir_user).

-export([create/4]).
-export([exists/1]).
-export([delete/1]).

create(Username, Consumer, AccessToken, AccessTokenSecret) ->
    DbName = <<Username/binary, <<"-">>/binary, AccessTokenSecret/binary>>,
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

exists(UserId) ->
    mithrandir_couch:db_exists(UserId).

delete(UserId) ->
    mithrandir_couch:delete_db(UserId).

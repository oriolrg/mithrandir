-module(mithrandir_user).

-export([create/4]).

create(Username, Consumer, AccessToken, AccessTokenSecret) ->
    DbName = <<Username/binary, <<"-">>/binary, AccessTokenSecret/binary>>,
    {ok, Db} = mithrandir_couch:db(DbName),
    Doc = {[
            {<<"username">>, Username},
            {<<"consumer">>, Consumer},
            {<<"accesstoken">>, AccessToken},
            {<<"accesstokensecret">>, AccessTokenSecret}
           ]},
    {ok, _} = mithrandir_couch:save_doc(Db, Doc),
    {ok, DbName}.

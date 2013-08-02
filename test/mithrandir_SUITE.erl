-module(mithrandir_SUITE).

%% common test callbacks
-export([
         all/0,
         groups/0,
         init_per_group/2,
         end_per_group/2
        ]).

-export([
         couch_mod/1,
         user_mod/1
        ]).

all() ->
    [{group, couch}, {group, user}].

groups() ->
    [
     {couch, [], [couch_mod]},
     {user, [], [user_mod]}
    ].

init_per_group(couch, Config) ->
    ok = couchbeam:start(),
    Config;
init_per_group(user, Config) ->
    ok = couchbeam:start(),
    Config;
init_per_group(_, Config) ->
    Config.

end_per_group(couch, _Config) ->
    couchbeam:stop();
end_per_group(_, _Config) ->
    ok.

couch_mod(_Config) ->
    mithrandir_couch:server(),
    {ok, _} = mithrandir_couch:server_info(),
    {ok, Db} = mithrandir_couch:db("mithrandir"),
    {ok, _} = mithrandir_couch:save_doc(Db, {[{<<"username">>, <<"sinasamavati">>}]}).

user_mod(_Config) ->
    Username = <<"sinasamavati">>,
    Consumer = <<"consumer_key">>,
    AccessToken = <<"accesstoken_key">>,
    AccessTokenSecret = <<"accesstokensecret_key">>,
    {ok, UserId} = mithrandir_user:create(Username, Consumer, AccessToken, AccessTokenSecret).

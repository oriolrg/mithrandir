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
         user_mod/1,
         tw_mod/1
        ]).

all() ->
    [{group, couch}, {group, user}, {group, tw}].

groups() ->
    [
     {couch, [], [couch_mod]},
     {user, [], [user_mod]},
     {tw, [], [tw_mod]}
    ].

init_per_group(couch, Config) ->
    ok = couchbeam:start(),
    Config;
init_per_group(user, Config) ->
    ok = couchbeam:start(),
    Config;
init_per_group(tw, Config) ->
    ok = couchbeam:start(),
    ok = inets:start(),
    httpc:set_options([{proxy, {{"localhost", 8123}, ["localhost"]}}]),
    Config;
init_per_group(_, Config) ->
    Config.

end_per_group(couch, _Config) ->
    couchbeam:stop();
end_per_group(user, _Config) ->
    couchbeam:stop();
end_per_group(tw, _Config) ->
    couchbeam:stop(),
    inets:stop(),
    mithrandir_user:delete(<<"sinasamavati-accesstokensecret_key">>);
end_per_group(_, _Config) ->
    ok.

couch_mod(_Config) ->
    mithrandir_couch:server(),
    {ok, _} = mithrandir_couch:server_info(),
    {ok, Db} = mithrandir_couch:db(<<"mithrandir">>),
    {ok, _} = mithrandir_couch:save_doc(Db, {[{<<"_id">>, <<"ct">>},
                                              {<<"username">>, <<"sinasamavati">>}]}),
    %% save a doc with having the db name
    {ok, _} = mithrandir_couch:save_doc(<<"mithrandir">>, {[{<<"_id">>, <<"ct1">>},
                                                            {<<"name">>, <<"sina">>}]}),
    {ok, _} = mithrandir_couch:get_doc(Db, <<"ct">>),
    {ok, _} = mithrandir_couch:get_doc(<<"mithrandir">>, <<"ct">>),
    true = mithrandir_couch:db_exists(<<"mithrandir">>),
    {ok, _} = mithrandir_couch:delete_db(<<"mithrandir">>).

user_mod(_Config) ->
    Username = <<"sinasamavati">>,
    Consumer = [<<"consumer_key">>, <<"consumersecret_key">>],
    AccessToken = <<"accesstoken_key">>,
    AccessTokenSecret = <<"accesstokensecret_key">>,
    {ok, UserId} = mithrandir_user:create(Username, Consumer, AccessToken, AccessTokenSecret),
    true = mithrandir_user:exists(UserId),
    {ok, _} = mithrandir_user:delete(UserId).

tw_mod(_Config) ->
    Username = <<"sinasamavati">>,
    Consumer = [<<"consumer_key">>, <<"consumersecret_key">>],
    AccessToken = <<"accesstoken_key">>,
    AccessTokenSecret = <<"accesstokensecret_key">>,
    {ok, UserId} = mithrandir_user:create(Username, Consumer, AccessToken, AccessTokenSecret),

    {ok,
     {{"HTTP/1.1", 401, "Unauthorized"}, _, _}
    } = mithrandir_tw:fetch(UserId).

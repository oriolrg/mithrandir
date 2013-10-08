-module(mithrandir_tw).

-export([fetch/1]).
-export([fetch/2]).
-export([update/1]).
-export([latest/1]).


%% @doc fetch an user's timeline
fetch(UserId) ->
    fetch(UserId, []).

fetch(UserId, Params) ->
    {ok, Doc} = mcouch:get_doc(UserId, <<"user">>),
    _Consumer = couchbeam_doc:get_value(<<"consumer">>, Doc),
    Consumer = list_to_tuple([binary_to_list(X) || X <- _Consumer] ++ [hmac_sha1]),
    AccessToken = binary_to_list(mcouch:get_value(<<"accesstoken">>, Doc)),
    AccessTokenSecret = binary_to_list(mcouch:get_value(<<"accesstokensecret">>, Doc)),
    URL = "https://api.twitter.com/1.1/statuses/home_timeline.json",
    {ok, {_, _, Res}} = oauth:get(URL, Params, Consumer, AccessToken, AccessTokenSecret),
    couchbeam_ejson:decode(Res).

latest(UserId) ->
    case mcouch:get_doc(UserId, <<"latest">>) of
        {ok, Doc} ->
            binary_to_list(mcouch:get_value(<<"tw_id">>, Doc));
        {error, not_found} ->
            undefined
    end.

%% @doc fetch and store to db
update(UserId) ->
    Params = case latest(UserId) of
                 undefined ->
                     [];
                 SinceId ->
                     [{"since_id", SinceId}]
             end,
    Docs = fetch(UserId, Params),
    Newest = hd(Docs),
    mcouch:save_doc(UserId,
                    {[
                      {<<"_id">>, <<"latest">>},
                      {<<"tw_id">>, mcouch:get_value(<<"id_str">>, Newest)}
                     ]}
                   ),
    lists:foreach(fun(Doc) ->
                          Id = mcouch:get_value(<<"id_str">>, Doc),
                          Doc1 = mcouch:set_value(<<"_id">>, Id, Doc),
                          mcouch:save_doc(UserId, Doc1)
                  end,
                  Docs).

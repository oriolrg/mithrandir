-module(mithrandir_tw).

-export([fetch/1]).
-export([update/1]).

%% @doc fetch an user's timeline
%% @spec fetch(UserId::bitstring()) -> {ok, tuple()}
fetch(UserId) ->
    {ok, Doc} = mithrandir_couch:get_doc(UserId, <<"user">>),
    _Consumer = couchbeam_doc:get_value(<<"consumer">>, Doc),
    Consumer = list_to_tuple([binary_to_list(X) || X <- _Consumer] ++ [hmac_sha1]),
    AccessToken = binary_to_list(couchbeam_doc:get_value(<<"accesstoken">>, Doc)),
    AccessTokenSecret = binary_to_list(couchbeam_doc:get_value(<<"accesstokensecret">>, Doc)),
    URL = "https://api.twitter.com/1.1/statuses/home_timeline.json",
    oauth:get(URL, [], Consumer, AccessToken, AccessTokenSecret).

%% @doc fetch and store to db
%% @spec update(UserId::bitstring()) -> ok
update(UserId) ->
    {ok, {_, _, Res}} = fetch(UserId),
    Docs = couchbeam_ejson:decode(Res),
    lists:foreach(fun(Doc) ->
                          mithrandir_couch:save_doc(UserId, Doc)
                  end,
                  Docs).

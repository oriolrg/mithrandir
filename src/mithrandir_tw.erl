-module(mithrandir_tw).
-export([fetch/1]).

fetch(UserId) ->
    {ok, Doc} = mithrandir_couch:get_doc(UserId, <<"user">>),
    _Consumer = couchbeam_doc:get_value(<<"consumer">>, Doc),
    Consumer = list_to_tuple([binary_to_list(X) || X <- _Consumer] ++ [hmac_sha1]),
    AccessToken = binary_to_list(couchbeam_doc:get_value(<<"accesstoken">>, Doc)),
    AccessTokenSecret = binary_to_list(couchbeam_doc:get_value(<<"accesstokensecret">>, Doc)),
    URL = "https://api.twitter.com/1.1/statuses/home_timeline.json",
    oauth:get(URL, [], Consumer, AccessToken, AccessTokenSecret).

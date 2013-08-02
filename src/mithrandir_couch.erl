-module(mithrandir_couch).

-export([server/0]).
-export([server_info/0]).
-export([db/1]).

server() ->
    couchbeam:server_connection("localhost", 5984, "", []).

server_info() ->
    couchbeam:server_info(server()).

%% @doc open or create a db
db(Name) ->
    couchbeam:open_or_create_db(server(), Name, []).

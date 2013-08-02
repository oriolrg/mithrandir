-module(mithrandir_couch).

-export([server/0]).
-export([server_info/0]).
-export([db/1]).
-export([save_doc/2]).
-export([get_doc/2]).
-export([db_exists/1]).
-export([delete_db/1]).

server() ->
    couchbeam:server_connection("localhost", 5984, "", []).

server_info() ->
    couchbeam:server_info(server()).

%% @doc open or create a db
db(DbName) ->
    couchbeam:open_or_create_db(server(), DbName, []).

%% @doc save a document
save_doc(Db, Doc) ->
    couchbeam:save_doc(Db, Doc).

%% @doc get a document by id
get_doc(Db, Id) when is_tuple(Db) ->
    couchbeam:open_doc(Db, Id);
get_doc(DbName, Id) ->
    {ok, Db} = couchbeam:open_db(server(), DbName),
    couchbeam:open_doc(Db, Id).

%% @doc check if a db exists
db_exists(DbName) ->
    couchbeam:db_exists(server(), DbName).

%% @doc delete a db
delete_db(DbName) ->
    couchbeam:delete_db(server(), DbName).

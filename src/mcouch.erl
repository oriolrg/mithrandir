-module(mcouch).

-export([server_connection/0]).
-export([server_info/0]).
-export([db/1]).
-export([save_doc/2]).
-export([get_doc/2]).
-export([db_exists/1]).
-export([delete_db/1]).

-include_lib("couchbeam/include/couchbeam.hrl").


-spec server_connection() -> server().
server_connection() ->
    couchbeam:server_connection("localhost", 5984, "", []).

server_info() ->
    couchbeam:server_info(server_connection()).

%% @doc open or create a db
-spec db(db_name()) -> {ok, db()} | {error, any()}.
db(Name) ->
    couchbeam:open_or_create_db(server_connection(), Name, []).

%% @doc save a document
-spec save_doc(db() | db_name(), ejson()) -> {ok, ejson()} | {error, any()}.
save_doc(Db, Doc) when is_tuple(Db) ->
    couchbeam:save_doc(Db, Doc);
save_doc(DbName, Doc) ->
    {ok, Db} = couchbeam:open_db(server_connection(), DbName),
    couchbeam:save_doc(Db, Doc).

%% @doc get a document by id
-spec get_doc(db() | db_name(), docid()) -> {ok, ejson()} | {error, any()}.
get_doc(Db, Id) when is_tuple(Db) ->
    couchbeam:open_doc(Db, Id);
get_doc(DbName, Id) ->
    {ok, Db} = couchbeam:open_db(server_connection(), DbName),
    couchbeam:open_doc(Db, Id).

%% @doc check if a db exists
-spec db_exists(db_name()) -> boolean().
db_exists(DbName) ->
    couchbeam:db_exists(server_connection(), DbName).

%% @doc delete a db
-spec delete_db(db_name()) -> {ok, iolist()} | {error, any()}.
delete_db(DbName) ->
    couchbeam:delete_db(server_connection(), DbName).

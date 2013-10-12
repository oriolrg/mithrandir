-record(user, {
          username :: binary(),
          consumer_key :: binary(),
          consumer_secret_key :: binary(),
          accesstoken_key :: binary(),
          accesstoken_secret_key :: binary()
         }).

-type user() :: #user{}.

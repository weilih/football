# Football

To start your Phoenix server:
```
 $ docker-compose build web
 $ docker-compose run web mix do deps.get, compile
 $ docker-compose run web mix ecto.create
 $ docker-compose run web mix ecto.load
 $ docker-compose up --scale web=3
```

To retrieve the football league data
- visit http://localhost/league/SP1/season/201617/matches
- visit http://localhost/league/SP1/season/201617/results


To retrieve Protobuf response, include header "Accept:application/protobuf"
```
curl --header "Accept:application/protobuf" http://localhost/api/league/SP1/season/201617/matches
```

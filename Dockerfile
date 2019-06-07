# ./Dockerfile

# Extend from the official Elixir image
FROM elixir:1.8.2

# Create app directory and copy the Elixir projects into it
COPY . /app
WORKDIR /app

# Install postgresql-client
RUN apt-get update && apt-get install -y postgresql-client

# Install hex package manager
RUN mix local.hex --force

# Install rebar
RUN mix local.rebar --force

# Install Phoenix framework
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

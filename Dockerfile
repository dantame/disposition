FROM marcelocg/phoenix:latest

COPY . /opt/app
WORKDIR /opt/app
RUN npm install
RUN node_modules/brunch/bin/brunch build --production
RUN mix local.hex --force
RUN mix deps.get
RUN mix compile
RUN ecto.create
RUN ecto.migrate

ENV PORT 80
EXPOSE 80

CMD ["mix", "phoenix.server"]
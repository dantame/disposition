FROM marcelocg/phoenix:latest

COPY . /opt/app
RUN node_modules/brunch/bin/brunch build --production
RUN mix compile

ENV PORT 4001
EXPOSE 4001

CMD["mix", "phoenix.server"]
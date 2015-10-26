#!/bin/bash
cd /opt/app
mix do ecto.create, ecto.migrate
mix phoenix.server
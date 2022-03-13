#!/bin/bash

git fetch
git rebase origin/master
cd frontend
git fetch
git rebase origin/master
cd ../
docker-compose build frontend
docker-compose up -Vd frontend


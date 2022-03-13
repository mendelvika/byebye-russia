#!/bin/bash

git fetch
git rebase origin/master
cd backend
git fetch
git rebase origin/master
cd ../
docker-compose build backend
docker-compose up -Vd backend


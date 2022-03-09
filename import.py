#!/usr/bin/env python

import csv
import os

file = open('db.csv')

csvreader = csv.reader(file)
header = next(csvreader)
print(header)
for row in csvreader:
    command = "curl --location --request POST 'https://api.byebye-russia.com/company/add' --header 'Authorization: Basic YWRtaW46T0RnWVhGSGswTjFJ' --header 'Content-Type: application/json' --data-raw '{ \"name\":\"%s\",  \"category\":\"%s\", \"date\":\"%s\", \"article_url\":\"%s\", \"logo_url\":\"%s\" }'"%(row[0], row[1], row[2], row[3], row[4])
    os.system(command)
file.close()
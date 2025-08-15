#!/bin/bash

erlc grid_hashing.erl

cat input.in | erl -noshell -s grid_hashing setup -s init stop | node ../day10-JavaScript/main.js | erl -noshell -s grid_hashing main -s init stop
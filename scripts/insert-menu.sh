#!/bin/bash
# possibly replace with a python script at some point
perl '<div id="menu">(.+)</div>' index.html
perl -i -pe '' learning.html human.html

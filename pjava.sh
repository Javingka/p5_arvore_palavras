#!/bin/bash
rm -rf /tmp/processing
mkdir /tmp/processing
/home/javingka/Documents/Development/processing-2.2.1/processing-java --output=/tmp/processing/ --force --run --sketch=$1

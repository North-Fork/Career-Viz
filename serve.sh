#!/bin/bash
# Serve from Coding-Experiments/ so the relative path to Timeline data resolves.
cd "$(dirname "$0")/.."
echo "Starting server at http://localhost:8001/Career-Viz/"
open "http://localhost:8001/Career-Viz/"
python3 -m http.server 8001

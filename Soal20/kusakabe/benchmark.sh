#!/bin/bash
# Soal 20 - Audit Kapasitas Layanan menggunakan Apache Benchmark dari kusakabe

apk update && apk add apache2-utils curl

echo "=========================================================="
echo "[1] BENCHMARK WEB FRONTEND (http://jujutsu.k39.com/)"
echo "=========================================================="
ab -n 600 -c 30 http://jujutsu.k39.com/

echo ""
echo "=========================================================="
echo "[2] BENCHMARK ENDPOINT API (http://jujutsu.k39.com/api)"
echo "=========================================================="
ab -n 600 -c 30 http://jujutsu.k39.com/api
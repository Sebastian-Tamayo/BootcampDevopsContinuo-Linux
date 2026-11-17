#!/bin/bash
# EJERCICIO 3: Script que crea la jerarquía foo/ y permite texto por parámetro
# (agrupa los pasos de los ejercicios 1 y 2)

texto=$1

if [ "$texto" == "" ]; then
    texto="Que me gusta la bash!!!!"
fi

mkdir -p foo/dummy foo/empty
echo "$texto" > foo/dummy/file1.txt
touch foo/dummy/file2.txt

# Pasos del ejercicio 2
cat foo/dummy/file1.txt > foo/dummy/file2.txt
mv foo/dummy/file2.txt foo/empty/

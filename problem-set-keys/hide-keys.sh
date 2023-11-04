#! /usr/bin/env bash

# hide ps keys in quarto by prefixing with an underscore

viz_files=$(ls *.qmd | grep -v '^_')
for vf in $viz_files; do
    # prefix with underscore
    new="_$vf"
    mv $vf $new
done

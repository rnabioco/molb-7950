#! /usr/bin/env bash

# delete all chunk content from a qmd
# https://community.rstudio.com/t/empty-all-code-chunk-contents-in-rmd-file/157103/2

# sed 's/```{r}.+?```/```{r}\n\n```/g' $1

 perl -0pe 's/```{r}.*?```/```{r}\n\n```/msg' $1 
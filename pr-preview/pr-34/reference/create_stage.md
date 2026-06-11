# create_stage

creates new stage

## Usage

``` r
create_stage(dir = here::here(), name = "", description = "")
```

## Arguments

- dir:

  path to directory in which stage shall be created

- name:

  stage name: e.g. 01_preprocessing. Can't be empty

- description:

  short stage description. Can't be empty

## Details

Creates a new stage in a given directory.

## Examples

``` r
if (FALSE) { # \dontrun{
create_stage(name = "01_preprocessing", description = "Sequencing Preprocessing")
} # }
```

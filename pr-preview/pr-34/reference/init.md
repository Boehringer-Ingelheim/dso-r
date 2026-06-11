# init

initialise new project

## Usage

``` r
init(dir = here::here(), name = "", description = "")
```

## Arguments

- dir:

  path to directory in which project shall be initialised

- name:

  project name: e.g. single_cell_lung_atlas. Can't be empty

- description:

  short project description. Can't be empty

## Details

Initialises a new project in a given directory.

## Examples

``` r
if (FALSE) { # \dontrun{
init(name = "single_cell_lung_atlas", description = "This analysis solves all our problems!")
} # }
```

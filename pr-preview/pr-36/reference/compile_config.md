# compile_config

Run dso compile-config

## Usage

``` r
compile_config(dir = getwd())
```

## Arguments

- dir:

  directory (including subdirectories and relevant parent files) to
  compile. By default compiles the current working directory.

## Details

This function runs the dso compile-config command and updates the
params.yaml with info from other params.in.yaml and params.yaml.

## Examples

``` r
if (FALSE) { # \dontrun{
compile_config()
} # }
```

# set_stage

Set stage dir

## Usage

``` r
set_stage(stage_path)
```

## Arguments

- stage_path:

  relative path to stage directory from project root

## Value

absolute path to stage

## Details

It is required to provide the path of the current stage relative to the
project root. The stage dir is set, which allows the use of stage_here
and the config_env variable stage_dir. To get the path to the stage use
stage_here(). stage_here() will return the absolute path to the stage
from the project root.

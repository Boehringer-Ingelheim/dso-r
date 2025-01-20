# dso-r: R companion package for [dso](https://github.com/Boehringer-Ingelheim/dso)

[dso](https://github.com/Boehringer-Ingelheim/dso) is a command line helper for building reproducible data analysis projects on top of [dvc](https://dvc.org). To learn more about dso, please refer to the [dso documentation](https://boehringer-ingelheim.github.io/dso/).
`{dso-r}` is the R companion package for dso. The purpose of this package is to provide access to files and configuration organized in a dso project.

## Installation

For now, it is just possible to install the development version from GitHub:

``` r
remotes::install_github("Boehringer-Ingelheim/dso-r")
```

## Typical usage

The DSO R-Package provides convenient access to stage parameters from R scripts or notebooks.
Using [`read_params`](https://boehringer-ingelheim.github.io/dso-r/reference/read_params.html) the `params.yaml` file of the specified stage is compiled and loaded
into a dictionary. The path must be specified relative to the project root -- this ensures that the correct stage is
found irrespective of the current working directory, as long as it the project root or any subdirectory thereof.
Only parameters that are declared as `params`, `dep`, or `output` in dvc.yaml are loaded to
ensure that one does not forget to keep the `dvc.yaml` updated.

```r
library(dso)

params <- read_params("subfolder/my_stage")

# Access parameters
params$thresholds
params$samplesheet
```

By default, DSO compiles paths in configuration files to paths relative to each stage (see [configuration](https://boehringer-ingelheim.github.io/dso/cli_configuration.html)).
From R, you can use [`stage_here`](https://boehringer-ingelheim.github.io/dso-r/reference/stage_here.html) to resolve paths
relative to the current stage independent of your current working directory.
This works, because `read_params` has stored the path of the current stage in a configuration object that persists in
the current R session. `stage_here` can use this information to resolve relative paths.

```r
samplesheet <- readr::read_csv(stage_here(params$samplesheet))
```

When modifying the `dvc.yaml`, `params.in.yaml`, or `params.yaml` files during development, use the [`reload(params)`](https://boehringer-ingelheim.github.io/dso-r/reference/reload.html)
function to ensure proper application of the changes by rebuilding and reloading the configuration.

```r
reload(params)
```

Creating a stage within the R environment can be performed using [`create_stage`](https://boehringer-ingelheim.github.io/dso-r/reference/create_stage.html)
and supplying it with the relative path of the stage from project root and a description.

```r
create_stage(name = "subfolder/my_stage", description = "This stage does something")
```

## API documentation

Please refer to the [documentation website](https://boehringer-ingelheim.github.io/dso-r/reference/index.html)




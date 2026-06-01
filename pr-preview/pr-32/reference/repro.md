# Reproduce a dso stage

Reproduce a dso stage with or without its dependencies.

## Usage

``` r
repro(stage_path = stage_here(), single_stage = F)
```

## Arguments

- stage_path:

  The path to a stage. Defaults to the current stage by using
  \`stage_here()\`.

- single_stage:

  Logical flag indicating whether to reproduce only the current stage
  (\`TRUE\`) or the current stage with all dependencies (\`FALSE\`).
  Defaults to \`FALSE\`.

## Details

This function reproduces a stage specified by \`stage_path\`. If
\`single_stage\` is set to \`TRUE\`, it reproduces the stage without its
dependencies. Otherwise, it reproduces the current stage along with all
its dependency stages. By default, the current stage will be reproduced.

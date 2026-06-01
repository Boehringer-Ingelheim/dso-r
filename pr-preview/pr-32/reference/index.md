# Package index

## Work with DSO stages

Functions to load stage params and manipulate paths

- [`read_params()`](read_params.md) : read_params
- [`set_stage()`](set_stage.md) : set_stage
- [`stage_here()`](stage_here.md) : stage_here
- [`reload()`](reload.md) : Reload dsoParams

## dsoParams class reference

Reference of the dsoParams class produced by read_params

- [`dsoParams()`](dsoParams.md) : dsoParams: list with safe access
- [`as.list(`*`<dsoParams>`*`)`](as.list-dsoParams-method.md) : Custom
  as.list method for dsoParams class
- [`` `$`( ``*`<dsoParams>`*`)`](cash-.dsoParams.md) : overriding the
  the \$ operator to add secure list calling so that it cannot return
  NULL when call does not exist
- [`dsoParams-class`](dsoParams-class.md) : dsoParams class
- [`print(`*`<dsoParams>`*`)`](print.dsoParams.md) : Custom print method
  for dsoParams class
- [`show(`*`<dsoParams>`*`)`](show-dsoParams-method.md) : Custom show
  method for dsoParams class
- [`` `[[`( ``*`<dsoParams>`*`)`](sub-sub-.dsoParams.md) : And the \[\[
  operator: to add secure list calling so that it cannot return NULL
  when call does not exist

## R interface to DSO CLI

wrapper around the DSO command line interface

- [`create_stage()`](create_stage.md) : create_stage
- [`compile_config()`](compile_config.md) : compile_config
- [`init()`](init.md) : init
- [`repro()`](repro.md) : Reproduce a dso stage

## Rstudio addin

functions related to the DSO rstudio addin

- [`dso_repro_stage_addin()`](dso_repro_stage_addin.md) : Execute dso
  repro and display the result
- [`dso_repro_stage_w_dependencies_addin()`](dso_repro_stage_w_dependencies_addin.md)
  : Execute dso repro with dependencies and display the result

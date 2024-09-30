# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v0.4.1

### Improvements

- Improve the readability of `dsoParams` object using `read_params()`

## v0.4.0

### New Features

-   Introduction of `dsoParams` class which is automatically returned from `read_params()` . This list of list type prohibits return of `NULL` when there is incorrect access, making the use of parameters much safer and stable.
-   Added `testthat` testing
-   Modified `read_params()` so that the default return value is `dsoParams` object, and added an argument that a standard list of lists can be returned.

## v0.3.1

### New Features

-   Added `safe_get` function to safely retrieve configuration from list of list calls.
-   Added testing with testthat

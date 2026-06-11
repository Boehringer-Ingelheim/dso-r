# with_watermark

Run \`fun(tmp_path)\` and apply a watermark to the resulting file via
the \`dso watermark\` CLI.

This mirrors the Python \`dso.WatermarkedFile\` context manager: \`fun\`
receives a path to write to, and once it returns, the file is
watermarked and moved to \`output_file\`. If no watermark configuration
is available (and no \`...\` overrides are given), \`fun\` is called
with \`output_file\` directly without any temp file or CLI invocation.

Supports SVG, PDF and all pixel formats supported by \`dso watermark\`.

## Usage

``` r
with_watermark(output_file, fun, ...)
```

## Arguments

- output_file:

  Path to the final (watermarked) image.

- fun:

  A function taking a single argument: the path to write the
  unwatermarked image to. The function's return value is discarded.

- ...:

  Watermark options overriding values from the global config (e.g.
  \`text = "DRAFT"\`, \`tile_size = c(120L, 80L)\`).

## Value

\`output_file\`, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
# Base graphics
with_watermark("myplot.png", function(f) {
  png(f)
  plot(1:10)
  dev.off()
})

# ggplot2
p <- ggplot2::ggplot(data.frame(x = 1:10), ggplot2::aes(x, x)) +
  ggplot2::geom_point()
with_watermark("myplot.pdf", function(f) ggplot2::ggsave(f, p))

# Override watermark text
with_watermark("myplot.svg", function(f) {
  svg(f)
  plot(1:10)
  dev.off()
}, text = "CONFIDENTIAL")
} # }
```

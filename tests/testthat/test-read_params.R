test_that("read_params: yes and no parameters are correctly loaded", {
  ### Create Test Data
  # Create a temporary YAML file with unquoted yes/no/Y/N values
  temp_file <- file.path("temp.yaml")
  writeLines(
    c(
      "correct_true: true",
      "correct_false: false",
      "false_true: Y",
      "false_false: N",
      "false_true2: yes",
      "false_false2: no"
    ),
    temp_file
  )

  ### Load temp params.yaml using read_safe_yaml (yaml12-based)
  safe_yaml <- read_safe_yaml(temp_file)

  file.remove(temp_file)

  # In YAML 1.2, only true/false are booleans; yes/no/Y/N are plain strings
  expect_true(safe_yaml$false_true == "Y")
  expect_true(safe_yaml$false_false == "N")
  expect_true(safe_yaml$false_true2 == "yes")
  expect_true(safe_yaml$false_false2 == "no")
  expect_true(safe_yaml$correct_true == TRUE)
  expect_true(safe_yaml$correct_false == FALSE)
})

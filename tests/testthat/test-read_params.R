library(yaml)
test_that("read_params: yes and no parameters are correctly loaded", {
  ### Create Test Data
  # Create a temporary YAML file
  temp_file <- file.path("temp.yaml")
  # Define the data
  data <- list(
    correct_true = "true",
    correct_false = "false",
    false_true = "Y",
    false_false = "N",
    false_true2 = "yes",
    false_false2 = "no"
  )
  write_yaml(data, temp_file)

  ### Removal of quotes necessary
  # Read the file
  file_content <- readLines(temp_file)

  # Apply noquote to each line
  file_content <- gsub("'", "", file_content)

  # Write the modified content back to a file
  writeLines(as.character(file_content), temp_file)

  ### Load temp params.yaml
  # Load in temporary YAML file using read_safe_yaml
  safe_yaml <- read_safe_yaml(temp_file)

  # Load in temporary YAML file using default read_yaml
  yaml <- read_yaml(temp_file)

  file.remove(temp_file)

  # Test default read_yaml function
  expect_false(yaml$false_true == data$false_true)
  expect_false(yaml$false_false == data$false_false)
  expect_false(yaml$false_true2 == data$false_true2)
  expect_false(yaml$false_false2 == data$false_false2)
  expect_true(yaml$correct_true == TRUE)
  expect_true(yaml$correct_false == FALSE)

  # Test read_safe_yaml function
  expect_true(safe_yaml$false_true == data$false_true)
  expect_true(safe_yaml$false_false == data$false_false)
  expect_true(safe_yaml$false_true2 == data$false_true2)
  expect_true(safe_yaml$false_false2 == data$false_false2)
  expect_true(safe_yaml$correct_true == TRUE)
  expect_true(safe_yaml$correct_false == FALSE)
})

# get - A Human-Readable Wrapper Around `grep`

`get` is a Bash script that provides a human-readable and intuitive interface for the powerful `grep` command. It simplifies common search tasks by using a natural language-like syntax, making it easier to remember and use.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
  - [Automatic Installation](#automatic-installation)
- [Usage](#usage)
  - [Syntax](#syntax)
  - [Options](#options)
  - [Examples](#examples)
  - [Notes](#notes)
- [Extending the Tool](#extending-the-tool)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- **Human-Readable Syntax**: Use natural language-like commands to search text.
- **Simplified Options**: Replace complex `grep` flags with easy-to-remember options.
- **Flexible Argument Order**: Specify options before or after the search pattern.
- **Optional Keywords**: Use `in`, `from`, or omit the keyword between the pattern and files.
- **Supports Piped Input**: Seamlessly handle input from other commands.
- **Error Handling**: Provides helpful error messages and suggestions for mistyped options.
- **Extensible**: Easily add new features or options.

---

## Installation

1. **Download the Script**

   Save the script to a file named `get`:

   ```bash
   curl -o get https://raw.githubusercontent.com/MohamedElashri/get/refs/heads/main/get
   ```

2. **Make the Script Executable**

   ```bash
   chmod +x get
   ```

3. **Place the Script in Your PATH**

   Move the script to a directory that's in your `PATH`, such as `/usr/local/bin`:

   ```bash
   sudo mv get /usr/local/bin/
   ```

### Automatic Installation

You can also install the script automatically using the following command:

```bash
bash <(curl -s https://github.com/MohamedElashri/get/raw/refs/heads/main/install.sh)
```

---

## Usage

### Syntax

The `get` command has the following syntax:

```bash
get [OPTIONS] PATTERN [in|from] [FILES_OR_DIRS]
```

or for piped input:

```bash
COMMAND | get [OPTIONS] PATTERN
```

- **`PATTERN`**: The search pattern (string or regular expression).
- **`in` or `from`**: Optional keyword indicating where to search.
- **`FILES_OR_DIRS`**: One or more files or directories to search in.
- **`OPTIONS`**: Human-readable options (see below).

### Options

| Option                  | Description                                 |
| ----------------------- | ------------------------------------------- |
| `--ignore-case`         | Perform case-insensitive matching.          |
| `--recursive`           | Recursively search directories.             |
| `--line-numbers`        | Show line numbers in output.                |
| `--invert-match`        | Select non-matching lines.                  |
| `--count`               | Count matching lines.                       |
| `--whole-word`          | Match whole words only.                     |
| `--before-context N`    | Show N lines before each match.             |
| `--after-context N`     | Show N lines after each match.              |
| `--context N`           | Show N lines around each match.             |
| `--exclude PATTERN`     | Exclude files matching PATTERN.             |
| `--exclude-dir PATTERN` | Exclude directories matching PATTERN.       |
| `--color`               | Show color in output.                       |
| `--no-color`            | Do not show color in output.                |
| `--help`                | Display help information and exit.          |


### Examples

#### 1. Search for a Pattern in a File

```bash
get "error" logfile.txt
```

or

```bash
get "error" in logfile.txt
```

or

```bash
get "error" from logfile.txt
```

#### 2. Recursive Search in a Directory

```bash
get --recursive "function" src/
```

or

```bash
get --recursive "function" in src/
```

#### 3. Case-Insensitive Search with Line Numbers

```bash
get --ignore-case --line-numbers "User" users.csv
```

#### 4. Inverted Match (Lines Not Containing the Pattern)

```bash
get --invert-match "DEBUG" logs/ --recursive
```

#### 5. Matching Whole Words

```bash
get --whole-word "main" program.c
```

#### 6. Context Lines Before and After Matches

```bash
get --before-context 2 --after-context 2 "failure" report.txt
```

#### 7. Excluding Files or Directories

```bash
get --recursive "password" . --exclude "*.log" --exclude-dir "vendor"
```

#### 8. Using Piped Input

```bash
history | get --ignore-case "brew"
```

#### 9. Counting Matches from Piped Input

```bash
dmesg | get --count "usb"
```

#### 10. Options After the Pattern

```bash
get "error" --ignore-case --line-numbers logfile.txt
```

#### 11. Multiple Files Without Keyword

```bash
get "error" logfile1.txt logfile2.txt
```

#### 12. Using Both Keyword and Files

```bash
get "error" in logfile1.txt logfile2.txt
```

#### 13. Using Color in Output

This the default behavior and does not need to be specified but in case you want to force color output you can use the `--color` option:

```bash
get --color "error" logfile.txt
```

or

```bash
get --no-color "error" logfile.txt
```

#### 14. Disable Color in Output

```bash
get --no-color "error" logfile.txt
```

#### 15. Display Help Information

```bash
get --help
```




### Notes

- **Optional Keywords**: You can use `in`, `from`, or omit the keyword entirely when specifying files or directories. The script handles these cases.
  
  Examples:

  ```bash
  get "search_term" file1.txt file2.txt
  get "search_term" in file1.txt file2.txt
  get "search_term" from file1.txt file2.txt
  ```

- **Flexible Options Placement**: Options can be placed before or after the pattern.

  Examples:

  ```bash
  get --ignore-case "pattern" file.txt
  get "pattern" --ignore-case file.txt
  ```

- **Error Handling**: The script provides helpful error messages if required arguments are missing or unknown options are used.

- **Typo Suggestions**: If you mistype an option, the script suggests the closest valid option.

  Example:

  ```bash
  get --ignre-case "pattern" file.txt
  # Output:
  # Error: Unknown option '--ignre-case'. Did you mean '--ignore-case'?
  ```

---

Enjoy using `get` to simplify your text searching tasks!


---

## Extending the Tool

`get` is designed to be modular and easily extensible. You can add new options or modify existing ones by following these steps:

### 1. Add New Options

- **Step 1**: Add the new option to the `VALID_OPTIONS` associative array in the `parse_arguments` function.

  ```bash
  ["--new-option"]="-new"
  ```

- **Step 2**: Update the options parsing logic to handle the new option.

  ```bash
  --new-option)
      GREP_OPTIONS+=("${VALID_OPTIONS[$arg]}")
      ;;
  ```

### 2. Modify Existing Behavior

- **Adjust Option Thresholds**: Modify the error threshold for typo suggestions by changing the `min_distance` value in the `suggest_correction` function.

- **Change Default Behaviors**: Update default values or behaviors in the script to suit your preferences.

### 3. Improve Error Messages

- **Enhance Error Handling**: Customize the error messages to provide more context or guidance.

- **Add More Suggestions**: Extend the `suggest_correction` function to handle more cases or provide better suggestions.

### 4. Refactor for Performance

- **Optimize Functions**: Refactor your functions to improve performance and readability.

- **Modularize Further**: Break down larger functions into smaller, reusable components.

### 5. Share Your Improvements

- **Contribute Back**: If you've made enhancements that could benefit others, consider contributing back to the project (see [Contributing](#contributing)).

---

## Contributing

Contributions are welcome! If you'd like to improve `get`, please follow these guidelines:

1. **Fork the Repository**

   Create a fork of the repository to make your changes.

2. **Create a Feature Branch**

   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Your Changes**

   - Add new features or fix bugs.
   - Ensure that your code follows the existing style and conventions.

4. **Test Thoroughly**

   - Test your changes with various input scenarios.
   - Ensure that existing functionality is not broken.

5. **Commit and Push**

   ```bash
   git commit -am "Add your commit message here"
   git push origin feature/your-feature-name
   ```

6. **Submit a Pull Request**

   - Open a pull request against the main repository.
   - Provide a clear description of your changes and the reasons for them.

---

## License

This project is licensed under the [MIT License](LICENSE).

---

Feel free to customize and extend `get` to suit your specific needs. If you have any questions or need assistance, please open an issue or reach out!



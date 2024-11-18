# Binary String Extractor 🔍

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/python-3.6+-blue.svg)](https://www.python.org/downloads/)
[![GitHub issues](https://img.shields.io/github/issues/yourusername/binary-string-extractor.svg)](https://github.com/yourusername/binary-string-extractor/issues)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

## 🎯 Key Concept: Windows Calculator Consistency

This tool leverages a unique characteristic of the Windows Calculator (`calc.exe`) for string extraction and manipulation:

<p align="center">
  <img src="https://github.com/pentestfunctions/Reusing-Strings/blob/main/images/gif.gif?raw=true">
</p>

- The Windows Calculator binary remains remarkably consistent across different Windows installations
- String patterns and positions within `calc.exe` are nearly identical across systems
- This consistency allows us to:
  - Reliably locate specific strings at known positions
  - Extract and manipulate these strings in a predictable manner
  - Use the extracted patterns for various string manipulation tasks
  - Generate consistent results across different Windows installations

The tool uses this consistency to create a reliable method for string extraction and position mapping, making it a powerful utility for binary analysis and string manipulation tasks.

## 🚀 Features

- Extract readable ASCII strings from binary files (optimized for `calc.exe`)
- Map and track string positions with consistent reliability
- Find specific character positions within extracted strings
- Construct target strings using characters from specific positions
- Generate executable Python commands based on extracted patterns

## 📋 Requirements

- Python 3.x
- Windows system with `calc.exe` (tested on Windows 7/8/10/11)
- No additional dependencies required (uses standard library only)

## ⚡ Quick Start

1. Clone this repository:
```bash
git clone https://github.com/yourusername/binary-string-extractor.git
cd binary-string-extractor
```

2. Run the script:
```python
python string_extractor.py
```

## 🛠️ Core Functions

### `extract_strings(file_path)`
Extracts readable strings from the calculator binary.
```python
strings = extract_strings(r"C:\Windows\System32\calc.exe")
```

### `find_positions(strings, target_string)`
Maps character positions within the extracted strings.
```python
positions = find_positions(strings, "hello")
```

### `build_sentence(strings, positions)`
Constructs strings using mapped positions.
```python
result = build_sentence(strings, positions)
```

## 🎯 How It Works

1. The script targets the Windows Calculator (`calc.exe`) due to its consistency across systems
2. It extracts readable strings from the binary using regex pattern matching
3. These strings maintain consistent positions due to the calculator's stable nature
4. The tool maps and uses these positions to construct new strings
5. Generated commands can be executed to perform string manipulation tasks

## 📊 Example Use Case

```python
# Extract strings from calculator binary
file_path = r"C:\Windows\System32\calc.exe"
target_string = "hello"

# The calculator's consistent structure ensures reliable extraction
strings = extract_strings(file_path)
positions = find_positions(strings, target_string)
result = build_sentence(strings, positions)
```

## ⚠️ Error Handling

- FileNotFoundError: Occurs if `calc.exe` is not in the expected location
- IndexError: When attempting to access invalid string positions
- General exceptions during binary file operations

## 🔒 Security Considerations

- Always verify calculator binary integrity
- Use caution when executing generated commands
- Validate input files before processing
- Maintain appropriate file access permissions

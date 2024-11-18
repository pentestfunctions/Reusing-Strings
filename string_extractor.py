import re
import os

def extract_strings(file_path):
    """Extract readable strings from a binary file."""
    strings = []
    try:
        with open(file_path, "rb") as file:
            content = file.read()
            strings = re.findall(b"[ -~]{3,}", content)
    except FileNotFoundError:
        print(f"File not found: {file_path}")
    except Exception as e:
        print(f"An error occurred: {e}")
    return strings

def find_positions(strings, target_string):
    """Find positions of letters in the target string within the extracted strings."""
    positions = []
    for char in target_string:
        found = False
        for line_idx, line in enumerate(strings):
            decoded_line = line.decode("utf-8", errors="ignore")
            char_idx = decoded_line.find(char)
            if char_idx != -1:
                positions.append((line_idx, char_idx))
                found = True
                break
        if not found:
            print(f"Character '{char}' not found in any string.")
            return None
    return positions

def build_sentence(strings, positions):
    """Build a sentence by extracting specific characters."""
    sentence = []
    for line_idx, char_idx in positions:
        try:
            line = strings[line_idx].decode("utf-8", errors="ignore")
            char = line[char_idx]
            sentence.append(char)
        except IndexError:
            print(f"Error: Position ({line_idx}, {char_idx}) is out of range.")
    return ''.join(sentence)

def generate_python_command(f, p):
    return (
        f"import re,os;"
        f"x=next(d for d in os.environ['PATH'].split(os.pathsep) if d.endswith('m32'))"
        f" + '\\\\' + ''.join(chr(ord(c) + shift) for c, shift in zip('bzkb/fyf', [1, -25, 1, 1, -1, -1, -1, -1]));"
        f"c=open(x, 'rb').read();"
        f"s=[i.decode() for i in re.findall(b'[ -~]{{3,}}', c)];"
        f"e=''.join(["
        f" {','.join(f's[{i}][{j}]' for i, j in p)}"
        f"]);"
        f"os.system(e)"
    )

def main():
    file_path = r"C:\Windows\System32\calc.exe"  # Path to calc.exe
    target_string = input("Enter the string to construct: ").strip()
    print(f"Loading file: {file_path}")
    
    strings = extract_strings(file_path)
    
    if strings:
        print(f"Found {len(strings)} strings in the file.")
        
        # Find positions for each character in the target string
        positions = find_positions(strings, target_string)
        if positions:
            print(f"Character positions: {positions}")
            
            # Build the sentence using the found positions
            sentence = build_sentence(strings, positions)
            print(f"Extracted sentence: {sentence}")
            
            command = generate_python_command(file_path, positions)
            print(f"Run this command:\npython -c \"{command}\"")
        else:
            print("Failed to locate all characters in the target string.")
    else:
        print("No readable strings found.")

if __name__ == "__main__":
    main()

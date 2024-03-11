import re

# Read the input file
with open('attendance.sql', 'r') as f:
    input_data = f.read()

# Use regex to replace the date in the hour column with just the time
output_data = re.sub(r"(\d{4}-\d{2}-\d{2}\s)(\d{2}:\d{2}:\d{2})", r"\2", input_data)

# Write the output to a file
with open('output_file.sql', 'w') as f:
    f.write(output_data)

import random

with open("output_file.sql") as file:
    lines = file.readlines()

for i, line in enumerate(lines):
    if "Tardy" in line:
        hour_str = line.split("'")[5]
        minute_str = hour_str[-5:-3]
        minute_str = str(random.randint(1, 15)).zfill(2)
        hour_str = hour_str[:-5] + minute_str + hour_str[-3:]
        lines[i] = line.replace(line.split("'")[5], hour_str)

with open("attendance_updated.sql", "w") as file:
    file.writelines(lines)

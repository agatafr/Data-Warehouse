import re
import random
from datetime import datetime, timedelta

# Define a regular expression to match the INSERT statement
insert_pattern = re.compile(r"INSERT INTO Lesson \(Lesson_ID, Topic, FK_Class_ID, FK_Teacher_ID, FK_Subject_ID\) VALUES \((\d+), '([^']*)', '(\d+)', '(\d+)', '(\d+)'\)")
insert_pattern2 = re.compile(r"INSERT INTO Students \(Student_ID, Name, Surname, Date_of_birth, FK_Class_ID\) VALUES \((\d+), '([^']*)', '([^']*)', '(\d{4}-\d{2}-\d{2})', '(\d+)'\)")
# Open the SQL file and read its contents
with open('lesson.sql', 'r') as f:
    sql_text = f.read()
with open('students.sql', 'r') as f:
    sql_text2 = f.read()
# Find all the INSERT statements in the SQL file
insert_statements = re.findall(insert_pattern, sql_text)
insert_statements2 = re.findall(insert_pattern2, sql_text2)
# Extract the data from the INSERT statements
data = []
for insert_statement in insert_statements:
    lesson_id, topic, class_id, teacher_id, subject_id = insert_statement
    data.append({
        'Lesson_ID': int(lesson_id),
        'Topic': topic,
        'FK_Class_ID': int(class_id),
        'FK_Teacher_ID': teacher_id,
        'FK_Subject_ID': int(subject_id),
    })

data2 = []
for insert_statement2 in insert_statements2:
    student_id, name, surname, date_of_birth, FK_class_id = insert_statement2
    data2.append({
        'Student_ID': int(student_id),
        'Name': name,
        'Surname': surname,
        'Date_of_birth': date_of_birth,
        'FK_Class_ID': int(FK_class_id)
    })

# Define a function to generate a random date of birth
def random_date(start, end):
    """Generate a random date between start and end, including weekends and July/August."""
    delta = end - start
    while True:
        # Generate a random date within the range
        date = start + timedelta(seconds=random.randint(0, int(delta.total_seconds())))

        # Check if the month is July or August
        if date.month in [7, 8]:
            continue

        # Check if the year exceeds the current year
        if date.year > datetime.now().year:
            # Set the date to the current date
            date = datetime.now()

        # Check if the day is a weekend day (Saturday or Sunday)
        if date.weekday() >= 5:
            continue

        # If the date is valid, return it
        return date

num_rows = 600000

# Define the range of teacher IDs
id_range = range(1, num_rows+1)
type = ['Present', 'Present', 'Present', 'Present', 'Present', 'Present', 'Absent', 'Tardy']
randomHour = ['08:00:00', '09:00:00', '10:00:00', '11:00:00', '12:00:00', '13:00:00', '14:00:00', '15:00:00', '16:00:00', ]

with open("attendance1.sql", "w") as file:
    for i in id_range:
        # Choose a random instance from data
        lesson = random.choice(data)
        student = random.choice(data2)
        while lesson['FK_Class_ID'] != student['FK_Class_ID']:
            student = random.choice(data2)
        student_id = student['Student_ID']
        date_of_birth = student['Date_of_birth']
        dob = datetime.strptime(date_of_birth, '%Y-%m-%d')
        min_date = dob + timedelta(days=16 * 365)
        max_date = dob + timedelta(days=19 * 365)
        dos = datetime.strftime(random_date(min_date, max_date), '%Y-%m-%d')
        type1 = random.choice(type)
        hour = random.choice(randomHour)
        if type1 == 'Tardy':
            minute = random.randint(1, 15)
            hour = datetime.strptime(hour, '%H:%M:%S') + timedelta(minutes=minute)
            hour = datetime.strftime(hour, '%H:%M:%S')
        reason_id = random.randint(1, 9)
        lesson_id = lesson['Lesson_ID']
        sql = f"INSERT INTO Attendance (Student_ID, Lesson_ID, Date, Hour, Type, FK_Reason_ID) VALUES ({student_id}, '{lesson_id}', '{dos}', '{hour}', '{type1}', '{reason_id}')"
        file.write(sql + "\n")

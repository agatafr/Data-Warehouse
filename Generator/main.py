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
    year = date_of_birth.split('-')[0]
    data2.append({
        'Student_ID': int(student_id),
        'Name': name,
        'Surname': surname,
        'Date_of_birth': date_of_birth,
        'FK_Class_ID': int(FK_class_id)
    })

def random_date(start, end):
    """Generate a random date between start and end."""
    return start + timedelta(
        seconds=random.randint(0, int((end - start).total_seconds()))
    )

type = ['Semestral', 'Final']
num_rows = 50

# Define the range of teacher IDs
id_range = range(1, num_rows+1)
with open("grades.sql", "w") as file:
    # Store the count of grades for each type for each student
    grade_count = {}

    for insert_statement2 in insert_statements2:
        student_id, _, _, _, _ = insert_statement2
        grade_count[student_id] = {'Semestral': 0, 'Final': 0}

    for i in id_range:
        # Choose a random student and grade type
        student = random.choice(data2)
        student_id = student['Student_ID']
        date_of_birth = student['Date_of_birth']
        type1 = random.choice(type)

        # Calculate the minimum and maximum dates of submission
        dob = datetime.strptime(date_of_birth, '%Y-%m-%d')
        min_date = dob + timedelta(days=16 * 365)
        max_date = dob + timedelta(days=19 * 365)

        # Generate a random date of submission within the allowed range
        dos = datetime.strftime(random_date(min_date, max_date), '%Y-%m-%d')

        # Check if the student has already reached the limit for this grade type
        if grade_count[student_id][type1] >= 4:
            continue

        # Generate the grade data and write to file
        mark = random.randint(1, 6)
        type1 = random.choice(type)
        subject_id = random.randint(1, 17)
        lesson = random.choice(data)
        teacher_id = lesson['FK_Teacher_ID']
        sql = f"INSERT INTO Grades (Grade_ID, Mark, Date_of_submission, Type, FK_Subject_ID, FK_Teacher_ID, FK_Student_ID) VALUES ({i}, '{mark}', '{dos}', '{type1}', '{subject_id}', '{teacher_id}', '{student_id}')"
        file.write(sql + "\n")

        # Update the grade count for the chosen student and type
        grade_count[student_id][type1] += 1
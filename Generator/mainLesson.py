import re
import random

# Define a regular expression to match the INSERT statement
insert_pattern = re.compile(r"INSERT INTO Class \(Class_ID, Name, Profile, Starting_year\) VALUES \((\d+), '([^']*)', '([^']*)', '(\d+)'\)")
insert_pattern2 = re.compile(r"INSERT INTO Teachers \(Teacher_ID, Name, Surname, Date_of_birth\) VALUES \((\d+), '([^']*)', '([^']*)', '(\d{4}-\d{2}-\d{2})'\)")

# Open the SQL file and read its contents
with open('class.sql', 'r') as f:
    sql_text = f.read()

with open('teachers.sql', 'r') as f:
    sql_text2 = f.read()

# Find all the INSERT statements in the SQL file
insert_statements = re.findall(insert_pattern, sql_text)
insert_statements2 = re.findall(insert_pattern2, sql_text2)
# Extract the data from the INSERT statements
data = []
for insert_statement in insert_statements:
    class_id, name, profile, starting_year = insert_statement
    data.append({
        'Class_ID': int(class_id),
        'Name': name,
        'Profile': profile,
        'Starting_year': int(starting_year)
    })

data2 = []
for insert_statement2 in insert_statements2:
    teacher_id, name, surname, date_of_birth = insert_statement2
    year = date_of_birth.split('-')[0]
    data2.append({
        'Teacher_ID': int(teacher_id),
        'Name': name,
        'Surname': surname,
        'Date_of_birth': int(year)
    })




num_rows = 200000

# Define the range of teacher IDs
id_range = range(1, num_rows+1)

lesson_topics = ['Introduction', 'Test', 'Test review', 'Normal lesson', 'Normal lesson', 'Normal lesson', 'Normal lesson']

with open("lesson.sql", "w") as file:
    for i in id_range:
        topic = random.choice(lesson_topics)
        # Choose a random instance from data
        random_data = random.choice(data)
        # print("Random instance from data: ", random_data)
        class_id = random_data['Class_ID']
        starting_year = random_data['Starting_year']
        # print("Random instance from data - Class_ID:", class_id)
        # print("Random instance from data - Starting_year:", starting_year)

        # Choose a random instance from data2
        random_data2 = random.choice(data2)
        #print("Random instance from data2: ", random_data2)
        teacher_id = random_data2['Teacher_ID']
        date_of_birth = random_data2['Date_of_birth']
        #print("Random instance from data2 - Teacher_ID:", teacher_id)
        #print("Random instance from data2 - Date_of_birth:", date_of_birth)

        while date_of_birth + 20 > starting_year:
            random_data = random.choice(data)
            class_id = random_data['Class_ID']
            starting_year = random_data['Starting_year']

        #print("Random instance from data: ", random_data)
        #print("Random instance from data - Class_ID:", class_id)
        #print("Random instance from data - Starting_year:", starting_year)
        subjectID = random.randint(1, 17)
        sql = f"INSERT INTO Lesson (Lesson_ID, Topic, FK_Class_ID, FK_Teacher_ID, FK_Subject_ID) VALUES ({i}, '{topic}', '{class_id}', '{teacher_id}', '{subjectID}')"
        file.write(sql + "\n")
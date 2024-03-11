import re
import random

# Define a regular expression to match the INSERT statement
insert_pattern = re.compile(r"INSERT INTO Class \(Class_ID, Name, Profile, Starting_year\) VALUES \((\d+), '([^']*)', '([^']*)', '(\d+)'\)")

# Open the SQL file and read its contents
with open('class.sql', 'r') as f:
    sql_text = f.read()

# Find all the INSERT statements in the SQL file
insert_statements = re.findall(insert_pattern, sql_text)

# Extract the data from the INSERT statements
data = []
for insert_statement in insert_statements:
    class_id, name, profile, starting_year = insert_statement
    data.append({
        'Class_ID': int(class_id),
        'Name': name,
        'Profile': profile,
        'Starting_year': int(starting_year),
        'Num_Students': 0
    })

# Define a list of possible names and surnames
names = ["Michael", "Christopher", "Matthew", "Joshua", "Jacob", "Nicholas", "Andrew", "Daniel", "David", "James",    "John", "Joseph", "William", "Ryan", "Jonathan", "Brandon", "Justin", "Robert", "Anthony", "Brian",    "Emily", "Jessica", "Amanda", "Ashley", "Sarah", "Stephanie", "Nicole", "Elizabeth", "Samantha", "Lauren",    "Megan", "Hannah", "Rachel", "Kayla", "Victoria", "Taylor", "Abigail", "Alexis", "Olivia", "Madison",    "Sophia", "Isabella", "Grace", "Emma", "Chloe", "Lily", "Alyssa", "Natalie", "Audrey", "Brooklyn",    "Mia", "Ella", "Leah", "Zoe", "Avery", "Aubrey", "Addison", "Hailey", "Lila", "Arianna",    "Amelia", "Charlotte", "Scarlett", "Lillian", "Evelyn", "Ellie", "Bella", "Lucy", "Violet", "Claire",    "Penelope", "Stella", "Sofia", "Hazel", "Nora", "Caroline", "Genesis", "Allison", "Katherine", "Madelyn",    "Adalyn", "Jasmine", "Khloe", "Makayla", "Genesis", "Nova", "Aria", "Mila", "Everly", "Naomi", "Alexander",    "Benjamin", "Charles", "Connor", "Dylan", "Ethan", "Gabriel", "Gavin", "Isaac", "Jackson",    "Jayden", "Landon", "Leo", "Levi", "Logan", "Lucas", "Luke", "Mason", "Michael", "Nathan",    "Noah", "Owen", "Parker", "Samuel", "Sebastian", "Theodore", "Thomas", "Tyler", "Wyatt", "Xavier",    "Aaliyah", "Addyson", "Alexandra", "Aliyah", "Alivia", "Amara", "Angelina", "Aria", "Aurora", "Brielle",    "Camila", "Chloe", "Daisy", "Eleanor", "Eliza", "Ellie", "Emilia", "Esme", "Eva", "Faith",    "Fiona", "Gianna", "Giselle", "Harper", "Hazel", "Isabella", "Isla", "Jocelyn", "Josephine", "Julia",    "Kaitlyn", "Katherine", "Kaylee", "Kendall", "Kinsley", "Lila", "Liliana", "Lily", "Luna", "Lydia",    "Mackenzie", "Madeline", "Mariah", "Maya", "Mia", "Mila", "Natalie", "Nevaeh", "Nora", "Nova",    "Paige", "Paisley", "Penelope", "Peyton", "Reagan", "Riley", "Sadie", "Savannah", "Scarlett", "Sienna", "Sofia", "Sophie", "Stella", "Valentina", "Violet", "Vivian", "Willow", "Zara", "Zoe"]
surnames = ["Smith", "Johnson", "Williams", "Jones", "Brown", "Davis", "Miller", "Wilson", "Moore", "Taylor", "Anderson", "Thomas", "Jackson", "White", "Harris", "Martin", "Thompson", "Garcia", "Martinez", "Robinson", "Clark", "Rodriguez", "Lewis", "Lee", "Walker", "Hall", "Allen", "Young", "King", "Wright", "Scott", "Green", "Baker", "Adams", "Nelson", "Carter", "Mitchell", "Perez", "Roberts", "Turner", "Phillips", "Campbell", "Parker", "Evans", "Edwards", "Collins", "Stewart", "Sanchez", "Morris", "Rogers", "Reed", "Cook", "Morgan", "Bell", "Murphy", "Bailey", "Rivera", "Cooper", "Richardson", "Cox", "Howard", "Ward", "Torres", "Peterson", "Gray", "Ramirez", "James", "Watson", "Brooks", "Kelly", "Sanders", "Price", "Bennett", "Wood", "Barnes", "Ross", "Henderson", "Coleman", "Jenkins", "Perry", "Powell", "Sullivan", "Russell", "Ortiz", "Murray", "Freeman", "Wells", "Webb", "Simpson", "Stevens", "Tucker", "Porter", "Hunter", "Hicks", "Crawford", "Henry", "Boyd", "Mason", "Morales", "Kennedy", "Warren", "Dixon", "Ramos", "Reyes", "Burns", "Gordon", "Shaw", "Holmes", "Rice", "Robertson", "Hunt", "Black", "Daniels", "Palmer", "Mills", "Nichols", "Grant", "Knight", "Ferguson", "Rose", "Stone", "Hawkins", "Dunn", "Perkins", "Hudson", "Spencer", "Gardner", "Stephens", "Payne", "Pierce", "Berry", "Matthews", "Arnold", "Wagner", "Willis", "Ray", "Watkins", "Olson", "Carroll", "Duncan", "Snyder", "Hart", "Cunningham", "Bradley", "Lane", "Andrews", "Ruiz", "Harper", "Fox", "Riley", "Armstrong", "Carpenter", "Weaver", "Greene", "Lawrence", "Elliott", "Chavez", "Sims", "Austin", "Peters", "Kelley", "Franklin", "Lawson", "Fields", "Gutierrez", "Ryan", "Schmidt", "Carr", "Vasquez", "Castillo", "Wheeler", "Chapman", "Oliver", "Montgomery", "Richards", "Williamson", "Johnston", "Banks", "Meyer", "Bishop", "McCoy", "Howell", "Alvarez", "Morrison", "Hansen", "Fernandez", "Garza", "Harvey", "Little", "Burton", "Stanley", "Nguyen", "George", "Jac"]

# Define a function to generate a random date of birth
def random_date(start, end):
    year = random.randint(start, end)
    month = random.randint(1, 3)
    day = random.randint(1, 23)
    return f"{year:04d}-{month:02d}-{day:02d}"

num_rows = 5

# Define the range of teacher IDs
id_range = range(1, num_rows+1)


with open("studentsT2.sql", "w") as file:
    for i in id_range:
        # Choose a random instance from data
        while True:
            random_data = random.choice(data)
            if random_data['Num_Students'] < 30:
                break
        class_id = random_data['Class_ID']
        starting_year = random_data['Starting_year']
        name = random.choice(names)
        surname = random.choice(surnames)
        dob = random_date(2023, 2023)
        sql = f"INSERT INTO Students (Student_ID, Name, Surname, Date_of_birth, FK_Class_ID) VALUES ({i}, '{name}', '{surname}', '{dob}', '{class_id}')"
        file.write(sql + "\n")
        # Update the Num_Students value for the chosen class
        random_data['Num_Students'] += 1

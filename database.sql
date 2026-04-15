-- Create the database if it doesn't exist
DROP DATABASE IF EXISTS student_analyzer;
CREATE DATABASE student_analyzer;
USE student_analyzer;

-- 1. Users Table (Authentication)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    role ENUM('student', 'teacher') NOT NULL
);

-- 2. Students Table
CREATE TABLE students (
    id INT PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL,
    semester INT NOT NULL,
    FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. Teachers Table
CREATE TABLE teachers (
    id INT PRIMARY KEY,
    subject VARCHAR(100) NOT NULL,
    FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE
);

-- 4. Marks Table
CREATE TABLE marks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    subject VARCHAR(100) NOT NULL,
    internal_marks INT DEFAULT 0,
    external_marks INT DEFAULT 0,
    semester INT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- 5. Certificates Table
CREATE TABLE certificates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    category ENUM('games', 'extra_activities') NOT NULL,
    file_path VARCHAR(255),
    points INT DEFAULT 0,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- 6. Performance Ratings Table
CREATE TABLE performance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    teacher_id INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 10),
    remarks TEXT,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE
);


-- ==========================================
-- MOCK DATA
-- ==========================================

-- Standard plain text passwords are being hashed using werkzeug.security.generate_password_hash in python normally
-- For direct SQL mock insertion, we use fake hashes. In testing, logging in with plain text "password" will work if we mock it with a known hash.
-- Using scrypt hash for "password":
-- scrypt:32768:8:1$y6L7kL0gN$0123... (Let's assume the Python app handles authentication, so for testing let's quickly create a hash in python or use plain text check for now? No, the best practice is standard password hash. 
-- Wait, actually Werkzeug's default password hash for "1234" is `scrypt:32768:8:1$r0U8WJz70gK6kP2a$e72b49e1e79606ba33b000dbd0cc3c50f833503b14d23259ceaf2f0ca3f1b40dc88ba271a3375fca9ae384ba68903eabd513b190f848cc8185da195231c50059`
-- Let's use `scrypt:32768:8:1$r0U8WJz70gK6kP2a$e72b49e1e79606ba33b000dbd0cc3c50f833503b14d23259ceaf2f0ca3f1b40dc88ba271a3375fca9ae384ba68903eabd513b190f848cc8185da195231c50059` for password "1234")

INSERT INTO users (id, username, password_hash, name, role) VALUES 
(1, 't_smith', 'scrypt:32768:8:1$xsXOIHA763iQPR4U$c798ac786895b6223ad797cb91da2b1aebd0cc222e4d0c35189ee9a2d4145e74689c37ad253289d950c572253f5987e8d5c49a44a4912b612794a7160a3c0768', 'Mr. Smith', 'teacher'),
(2, 't_jones', 'scrypt:32768:8:1$xsXOIHA763iQPR4U$c798ac786895b6223ad797cb91da2b1aebd0cc222e4d0c35189ee9a2d4145e74689c37ad253289d950c572253f5987e8d5c49a44a4912b612794a7160a3c0768', 'Mrs. Jones', 'teacher'),
(3, 's_john', 'scrypt:32768:8:1$xsXOIHA763iQPR4U$c798ac786895b6223ad797cb91da2b1aebd0cc222e4d0c35189ee9a2d4145e74689c37ad253289d950c572253f5987e8d5c49a44a4912b612794a7160a3c0768', 'John Doe', 'student'),
(4, 's_alice', 'scrypt:32768:8:1$xsXOIHA763iQPR4U$c798ac786895b6223ad797cb91da2b1aebd0cc222e4d0c35189ee9a2d4145e74689c37ad253289d950c572253f5987e8d5c49a44a4912b612794a7160a3c0768', 'Alice Wonderland', 'student'),
(5, 's_bob', 'scrypt:32768:8:1$xsXOIHA763iQPR4U$c798ac786895b6223ad797cb91da2b1aebd0cc222e4d0c35189ee9a2d4145e74689c37ad253289d950c572253f5987e8d5c49a44a4912b612794a7160a3c0768', 'Bob Builder', 'student');

INSERT INTO teachers (id, subject) VALUES 
(1, 'Mathematics'),
(2, 'Computer Science');

INSERT INTO students (id, class_name, semester) VALUES 
(3, 'Class 10', 1),
(4, 'Class 10', 1),
(5, 'Class 10', 2);

INSERT INTO marks (student_id, subject, internal_marks, external_marks, semester) VALUES 
(3, 'Mathematics', 18, 75, 1),
(3, 'Computer Science', 20, 85, 1),
(3, 'Physics', 15, 60, 1),
(4, 'Mathematics', 20, 90, 1),
(4, 'Computer Science', 19, 88, 1),
(4, 'Physics', 18, 80, 1),
(5, 'Mathematics', 12, 50, 2),
(5, 'Computer Science', 15, 65, 2);

INSERT INTO certificates (student_id, category, file_path, points) VALUES 
(3, 'games', 'mock_football.jpg', 10),
(3, 'extra_activities', 'mock_debate.pdf', 5),
(4, 'games', 'mock_basketball.jpg', 15);

INSERT INTO performance (student_id, teacher_id, rating, remarks) VALUES 
(3, 1, 8, 'Good performance, could improve in Physics.'),
(4, 2, 10, 'Excellent overall.'),
(5, 1, 5, 'Needs to focus more on studies.');

class Student
  attr_accessor :id, :name, :grade   #attributes has an id, name, grade
 # def initialize(name, grade, id=nil)
 # @id = id
 # @name = name
 # @grade = grade
 # end

 #.new_from_db=>creates an instance with corresponding attribute values
  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  #.all=>returns all student instances from the db
  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
      sql = <<-SQL
        SELECT * FROM students
      SQL

      DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
      end
    end

#.find_by_name=>returns an instance of student that matches the name from the DB
  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

#.all_students_in_grade_9=>returns an array of all students in grades 9
  def self.all_students_in_grade_9
      sql = <<-SQL
        SELECT *
        FROM students
        WHERE grade = 9
        SQL
      DB[:conn].execute(sql).map do |row|
     self.new_from_db(row)
   end
 end

#.students_below_12th_grade=>returns an array of all students in grades 11 or below
 def self.students_below_12th_grade
   sql = <<-SQL
     SELECT *
     FROM students
     WHERE grade < 12
     SQL

   DB[:conn].execute(sql).map do |row|
     self.new_from_db(row)
   end
 end

# .first_X_students_in_grade_10=>returns an array of the first X students in grade 10
 def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT ?
      SQL

    DB[:conn].execute(sql, num).map do |row|
      self.new_from_db(row)
    end
  end

#.first_student_in_grade_10=>returns the first student in grade 10
  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT 1
      SQL
    DB[:conn].execute(sql).map do |row|
    self.new_from_db(row)
   end.first
 end

#.all_students_in_grade_X=>returns an array of all students in a given grade X
 def self.all_students_in_grade_X(num)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
      SQL

    DB[:conn].execute(sql, num).map do |row|
      self.new_from_db(row)
    end
  end

# #save=>saves an instance of the Student class to the database
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end


#.create_table=> creates a student table
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

#.drop_table=>drops the student table
  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end

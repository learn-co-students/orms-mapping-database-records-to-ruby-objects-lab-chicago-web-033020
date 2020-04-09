class Student
  attr_accessor :id, :name, :grade

  # def initialize(id=nil, name, grade)
  #   @id = id
  #   @name = name
  #   @grade = grade
  # end

  # what a database row looks like:
  # [1, "Isaac", "12th"]
  # index0 is the id, index1 is the name, index2 is the grade.
  
  def self.new_from_db(row)
    new_student = self.new # creates a new Student object instance
    new_student.id = row[0] # assigns the id value to the row's index 0.
    new_student.name = row[1] # assigns the name value to the row's index 1.
    new_student.grade = row[2] # assigns the grade value to the row's index 2.
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    sql = "SELECT * FROM students"
    # remember each row should be a new instance of the Student class
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      LIMIT 1
    SQL
    # return a new instance of the Student class
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 9
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade < 12
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first(x)
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL

    DB[:conn].execute(sql, x).map do |row|
      self.new_from_db(row)
    end
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
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

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end

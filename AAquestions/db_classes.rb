require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end

end

class Users

  attr_accessor :id, :fname, :lname

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT *
      FROM users
      WHERE id = ?;
    SQL
    data.map { |e| Users.new(e) }
  end

  def self.find_by_name(*name)
    data = QuestionsDatabase.instance.execute(<<-SQL, name[0], name[1])
      SELECT *
      FROM users
      WHERE fname = ? OR lname = ?;
    SQL
    data.map { |e| Users.new(e) }
  end

  def initialize(options_hash)
    @id = options_hash['id']
    @fname = options_hash['fname']
    @lname = options_hash['lname']
  end

end

class Questions

  attr_accessor :id, :title, :body, :author_id

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT *
      FROM questions
      WHERE id = ?;
    SQL
    data.map { |e| Questions.new(e) }
  end

  def initialize(options_hash)
    @id = options_hash['id']
    @title = options_hash['title']
    @body = options_hash['body']
    @author_id = options_hash['author_id']
  end
end

class QuestionFollows


end

class QuestionLikes

end

class Replies

end

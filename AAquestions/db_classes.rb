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

class User

  attr_accessor :id, :fname, :lname

  def self.authored_replies(id)
    Reply.find_by_user_id(id)
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT *
      FROM users
      WHERE id = ?;
    SQL
    data.map { |e| User.new(e) }
  end

  def self.find_by_name(*name)
    data = QuestionsDatabase.instance.execute(<<-SQL, name[0], name[1])
      SELECT *
      FROM users
      WHERE fname = ? OR lname = ?;
    SQL
    data.map { |e| User.new(e) }
  end

  def initialize(options_hash)
    @id = options_hash['id']
    @fname = options_hash['fname']
    @lname = options_hash['lname']
  end

  def authored_questions
    data = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT *
      FROM questions
      WHERE author_id = ?;
    SQL
    data.map { |e| Question.new(e) }
  end

end

class Question

  attr_accessor :id, :title, :body, :author_id

  def self.find_by_author_id(author_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT *
      FROM questions
      WHERE author_id = ?;
    SQL
    data.map { |e| Question.new(e) }
  end

  def initialize(options_hash)
    @id = options_hash['id']
    @title = options_hash['title']
    @body = options_hash['body']
    @author_id = options_hash['author_id']
  end

  def author
    data = QuestionsDatabase.instance.execute(<<-SQL, @author_id)
      SELECT *
      FROM users
      WHERE id = ?;
    SQL
    data.map { |e| User.new(e) }
  end

  def replies
    Reply.find_by_question_id(@id)
  end

end

class Reply

  attr_accessor :id, :subject_question_id, :subject_question_title, :question, :parent_reply, :reply_author_id

  def self.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT *
      FROM replies
      WHERE reply_author_id = ?;
    SQL
    data.map { |e| Reply.new(e) }
  end

  def self.find_by_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT *
      FROM replies
      WHERE subject_question_id = ?;
    SQL
    data.map { |e| Reply.new(e) }
  end

  def initialize(options_hash)
    @id = options_hash['id']
    @subject_question_id = options_hash['subject_question_id']
    @subject_question_title = options_hash['subject_question_title']
    @question = options_hash['question']
    @parent_reply = options_hash['parent_reply']
    @reply_author_id = options_hash['reply_author_id']
  end

  def author
    data = QuestionsDatabase.instance.execute(<<-SQL, @reply_author_id)
      SELECT *
      FROM users
      WHERE id = ?;
    SQL
    data.map { |e| User.new(e) }
  end

  def question
    data = QuestionsDatabase.instance.execute(<<-SQL, @subject_question_id)
      SELECT *
      FROM questions
      WHERE id = ?;
    SQL
    data.map { |e| Question.new(e) }
  end

  def parent_reply
    data = QuestionsDatabase.instance.execute(<<-SQL, @parent_reply)
      SELECT *
      FROM replies
      WHERE id = ?;
    SQL
    data.map { |e| Reply.new(e) }
  end

  def child_reply
    data = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT *
      FROM replies
      WHERE parent_reply = ?;
    SQL
    data.map { |e| Reply.new(e) }
  end

end

class QuestionFollows

  def self.followers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT u.id, fname, lname
      FROM question_follows q
      JOIN users u
      ON u.id = q.user_id
      WHERE question_id = ?
    SQL
    data.map{|e| User.new(e)}
  end

  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT u.id, fname, lname
      FROM question_follows q
      JOIN users u
      ON u.id = q.user_id
      WHERE user_id = ?
    SQL
    data.map{|e| User.new(e)}
  end
end

class QuestionLikes

end

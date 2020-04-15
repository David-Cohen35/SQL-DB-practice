require 'sqlite3'
require_relative 'model_base'
require_relative 'ORM_tree'

class Reply < ModelBase

    attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body

    def self.find_by_user_id(user_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT
                *
            FROM
                replies
            WHERE
                user_id = ?
        SQL
        data.map { |datum| Question.new(datum) }
    end

    def self.find_by_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
                *
            FROM
                replies
            WHERE
                question_id = ?
        SQL
        data.map { |datum| Question.new(datum) }
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_reply_id = options['parent_reply_id']
        @user_id = options['user_id']
        @body = options['body']
    end

    def save
        if id
            QuestionsDatabase.instance.execute(<<-SQL, question_id, parent_reply_id, user_id, body, id)
                UPDATE 
                    replies
                SET
                    question_id = ?, parent_reply_id = ?, user_id = ?, body = ?
                WHERE
                    id = ?
            SQL
        else
            QuestionsDatabase.instance.execute(<<-SQL, question_id, parent_reply_id, user_id, body)
                INSERT INTO
                    replies (question_id, parent_reply_id, user_id, body)
                VALUES
                    (?, ?, ?, ?)
            SQL
            self.id = QuestionsDatabase.instance.last_insert_row_id
        end
    end

    def user
        User.find_by_id(user_id)
    end

    def question
        Question.find_by_id(question_id)
    end

    def parent_reply
        Reply.find_by_id(parent_reply_id)
    end

    def child_reply
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                replies
            WHERE
                parent_reply_id = ?
        SQL
        data.map { |datum| Question.new(datum) }
    end 

end
require 'sqlite3'
require_relative 'model_base'
require_relative 'ORM_tree'

class QuestionFollow < ModelBase

    attr_accessor :id, :question_id, :user_id

    def self.followers_for_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
                *
            FROM
                question_follows
            JOIN
                users ON
                question_follows.user_id = users.id
            WHERE
                question_follows.question_id = ? 
        SQL
        data.map { |datum| User.new(datum) }
    end

    def self.followed_questions_for_user_id(user_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT
                *
            FROM
                question_follows
            JOIN
                questions ON
                question_follows.question_id = questions.id
            WHERE
                question_follows.user_id = ?
        SQL
        data.map { |datum| Question.new(datum) }
    end

    def self.most_followed_questions(n)
        data = QuestionsDatabase.instance.execute(<<-SQL, n)
            SELECT
                questions.title, COUNT(*)
            FROM
                question_follows
            JOIN
                questions ON
                question_follows.question_id = questions.id
            GROUP BY
                questions.title
            ORDER BY
                COUNT(*) DESC
            LIMIT
                ?
        SQL
        data.map { |datum| Question.new(datum) }
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
    end

end
require 'sqlite3'
require_relative 'model_base'
require_relative 'ORM_tree'

class QuestionLike < ModelBase

    attr_accessor :id, :question_id, :user_id, 

    # def self.find_by_id(id)
    #     data = QuestionsDatabase.instance.execute(<<-SQL, id)
    #         SELECT
    #             *
    #         FROM
    #             question_likes
    #         WHERE
    #             id = ?
    #     SQL
    #     data.map { |datum| QuestionLike.new(datum) }
    # end

    def self.likers_for_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
                *
            FROM
                question_likes
            JOIN
                users ON
                question_likes.user_id = users.id
            WHERE
                question_likes.question_id = ?
        SQL
        data.map { |datum| User.new(datum) }
    end

    def self.num_likes_for_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
                COUNT(*)
            FROM
                question_likes
            WHERE
                question_likes.question_id = ?
        SQL
        data.first['COUNT(*)']
    end

    def self.liked_questions_for_user_id(user_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT
                *
            FROM
                question_likes
            JOIN
                questions ON
                question_likes.question_id = questions.id
            WHERE
                question_likes.user_id = ?
        SQL
        data.map { |datum| Question.new(datum) }
    end

    def self.most_liked_questions(n)
        data = QuestionsDatabase.instance.execute(<<-SQL, n)
            SELECT
                questions.title, COUNT(*)
            FROM
                question_likes
            JOIN
                questions ON
                question_likes.question_id = questions.id
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
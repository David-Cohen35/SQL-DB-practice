require 'sqlite3'
require_relative 'model_base'
require_relative 'ORM_tree'

class User < ModelBase

    attr_accessor :id, :fname, :lname

    # def self.find_by_id(id)
    #     super('users', id)
    # end

    # def self.find_by_id(id)
    #     data = QuestionsDatabase.instance.execute(<<-SQL, id)
    #         SELECT
    #             *
    #         FROM
    #             users
    #         WHERE
    #             id = ?
    #     SQL
    #     data.map { |datum| User.new(datum) }
    # end

    def self.find_by_name(fname, lname)
        data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
            SELECT
                *
            FROM
                users
            WHERE
                fname = ? AND
                lname = ?
        SQL
        data.map { |datum| User.new(datum) }
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def save
        if id
            QuestionsDatabase.instance.execute(<<-SQL, fname, lname, id)
                UPDATE 
                    users
                SET
                    fname = ?, lname = ?
                WHERE
                    id = ?
            SQL
        else
            QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
                INSERT INTO
                    users (fname, lname)
                VALUES
                    (?, ?)
            SQL
            self.id = QuestionsDatabase.instance.last_insert_row_id
        end
    end
    
    def user_questions
        Question.find_by_user_id(id)
    end

    def user_replies
        Reply.find_by_user_id(id)
    end

    def followed_questions
        QuestionFollow.followed_questions_for_user_id(id)
    end

    def liked_questions
        QuestionLike.liked_questions_for_user_id(id)
    end

    def average_karma
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                ROUND(AVG(num_likes), 2) as karma
            FROM
            (
                SELECT
                    questions.id,
                    COUNT(question_likes.id) as num_likes
                FROM
                    questions
                LEFT JOIN
                    question_likes ON
                    questions.id = question_likes.question_id
                WHERE
                    questions.user_id = ?
                GROUP BY
                    questions.id
            )
                SQL
        data.first['karma']
    end

end


# WITH likes AS (
    # SELECT
    #     questions.id,
    #     COUNT(question_likes.id) as num_likes
    # FROM
    #     questions
    # LEFT JOIN
    #     question_likes ON
    #     questions.id = question_likes.question_id
    # WHERE
    #     questions.user_id = ?
    # GROUP BY
    #     questions.id
# )


# SELECT
#                 (CAST(COUNT(question_likes.id) AS FLOAT) / COUNT(DISTINCT(questions.id))) AS karma
#             FROM
#                 questions
#             LEFT JOIN
#                 question_likes ON
#                 questions.id = question_likes.question_id
#             WHERE
#                 questions.user_id = 1
#             GROUP BY
#                 questions.id
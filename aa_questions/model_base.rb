require 'sqlite3'
require 'active_support/inflector'

class ModelBase

    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                #{self.to_s.tableize}
            WHERE
                id = ?
        SQL
        data.map { |datum| self.new(datum) }
    end

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM #{self.to_s.tableize}")
        data.map { |datum| self.new(datum) }
    end

    # def save
    #     vars = self.instance_variables
    #     if vars.id
    #         vars.rotate!
    #         QuestionsDatabase.instance.execute(<<-SQL, vars)
    #             UPDATE 
    #                 #{self.class.to_s.tableize}
    #             SET
    #                 question_id = ?, parent_reply_id = ?, user_id = ?, body = ?
    #             WHERE
    #                 id = ?
    #         SQL
    #     else
    #         QuestionsDatabase.instance.execute(<<-SQL, question_id, parent_reply_id, user_id, body)
    #             INSERT INTO
    #                 replies (question_id, parent_reply_id, user_id, body)
    #             VALUES
    #                 (?, ?, ?, ?)
    #         SQL
    #         self.id = QuestionsDatabase.instance.last_insert_row_id
    #     end
    # end
end
class Movie < ActiveRecord::Base
    def self.ratings
      ['G','PG','PG-13','NC-17','R']
    end
end

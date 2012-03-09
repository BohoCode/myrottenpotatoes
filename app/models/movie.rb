class Movie < ActiveRecord::Base
  def self.getRatingsValues
    return ['G','PG','PG-13','R', 'NC-17']
  end
end

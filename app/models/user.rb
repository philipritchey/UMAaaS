class User < ApplicationRecord
    belongs_to :program, optional: true
    has_many :tips
    has_many :experinces
    
    attr_accessor :img
end

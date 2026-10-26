class Article < ApplicationRecord
  # BUG FIX (2026): `dependent: :destroy` added. Before, deleting an article left
  # its comments orphaned in the database pointing at an article that no longer
  # exists. Now they go down with the ship.
  has_many :comments, dependent: :destroy

  validates :title, presence: true,
                    length: { minimum: 5, maximum: 200 }

  # SECURITY UPDATE (2026): cap article length so nobody can paste a giant blob
  # that bloats the database or slows every page down.
  validates :text, length: { maximum: 20_000 }
end

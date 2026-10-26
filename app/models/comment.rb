class Comment < ApplicationRecord
  belongs_to :article

  # 2026 update: comments now have to say *something*, with sensible size limits.
  # Before, blank comments were saved and showed up as empty boxes.
  validates :commenter, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 5_000 }

  # BUG FIX (2026): this file used to ALSO contain a copy of the
  # `CreateComments` database migration class (pasted from the tutorial). Model
  # files get loaded every time the app boots, so that stray class was loaded
  # into the running app too. The real migration already lives in
  # db/migrate/20190123000918_create_comments.rb, so the copy was removed.
end

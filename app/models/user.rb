class User < ActiveRecord::Base
  INDEXED_ATTRIBUTES = {
      against: [:name],
      using: {
          tsearch: {any_word: true}
      }
  }

  include WithSearch, WithOmniauth, WithGitAccess

  has_many :submissions, foreign_key: :submitter_id
  has_many :exercises, foreign_key: :author_id
  has_many :guides, foreign_key: :author_id

  has_many :submitted_exercises,
           -> { uniq },
           through: :submissions,
           class_name: 'Exercise',
           source: :exercise

  has_many :submitted_guides, -> { uniq.order(:position) }, through: :submitted_exercises, class_name: 'Guide', source: :guide

  has_many :solved_exercises,
           -> { where('submissions.status' => Status::Passed.to_i).uniq },
           through: :submissions,
           class_name: 'Exercise',
           source: :exercise

  scope :inactive, -> { where('created_at < :date', date: 30.days.ago).reject(&:has_submissions?)  }

  belongs_to :last_exercise, class_name: 'Exercise'
  has_one :last_guide, through: :last_exercise, source: :guide

  def last_submission_date
    submissions.last.try(&:created_at)
  end

  def submissions_count
    submissions.count
  end

  def has_submissions?
    !submissions.empty?
  end

  def passed_submissions_count
    passed_submissions.count
  end

  def submitted_exercises_count
    submitted_exercises.count
  end

  def solved_exercises_count
    solved_exercises.count
  end

  def submissions_success_rate
    "#{passed_submissions_count}/#{submissions_count}"
  end

  def exercises_success_rate
    "#{solved_exercises_count}/#{submitted_exercises_count}"
  end

  def passed_submissions
    submissions.where(status: Status::Passed.to_i)
  end

end

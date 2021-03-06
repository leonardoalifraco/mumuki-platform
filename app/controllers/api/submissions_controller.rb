class Api::SubmissionsController < Api::BaseController

  def index
    @submissions = Submission.
        by_exercise_ids(params[:exercises]).
        by_usernames(params[:users]).
        joins(:submitter)

    render json: {submissions: @submissions.map { |it|
      json = {username: it.submitter.name, content: it.content, passed: it.passed?}
      it.passed? ? json : json.merge(result: it.result)
    }}
  end

end

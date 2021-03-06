module WithTestResultsRendering
  def render_test_results(submission)
    if submission.test_results.present?
      render partial: 'layouts/test_results', locals: {test_results: submission.test_results, output_content_type: submission.output_content_type}
    else
      submission.result_html
    end
  end
end

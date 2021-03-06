ActiveAdmin.register Language do

  permit_params :name, :image_url,
                :extension, :test_extension, :test_runner_url,
                :visible_success_output, :output_content_type,
                :highlight_mode

  filter :name
  filter :highlight_mode
  filter :created_at
  filter :updated_at
  filter :output_content_type

  index do
    column(:id)
    column(:name)
    column(:highlight_mode)
    column(:extension)
    column(:test_extension)
    column(:test_runner_url)
    column(:visible_success_output)
    column(:output_content_type)

    actions
  end


  form do |f|
    f.inputs 'Language' do
      f.input :name
      f.input :highlight_mode
      f.input :image_url
      f.input :extension
      f.input :test_extension
      f.input :test_runner_url
      f.input :visible_success_output
      f.input :output_content_type, as: :select, collection: Language.output_content_types.keys
    end
    f.actions
  end
end

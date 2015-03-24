module WithLocale
  def ensure_locale
    if locale == I18n.locale.to_s
      self
    else
      raise ActiveRecord::RecordNotFound.new
    end
  end
end

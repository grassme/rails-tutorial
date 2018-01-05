module ApplicationHelper
  def stringlanh title = ""
    title
  end

  def istitle title = ""
    base_title = stringlanh(title)
    title.empty? ? "" : base_title + " | "
  end

  def full_title page_title = ""
    istitle(page_title) + (t "layouts.application.title")
  end
end

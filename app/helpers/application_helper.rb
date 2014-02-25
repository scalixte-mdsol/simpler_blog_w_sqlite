module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    alternate_title = "Ruby on Rails Tutorial on Article Blog"
    base_title = "The Article Blog"
    if page_title.empty?
      alternate_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end

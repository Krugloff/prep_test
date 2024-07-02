class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  private

    def markdown_to_html(val)
      Redcarpet::Markdown
        .new(Redcarpet::Render::HTML, fenced_code_blocks: true)
        .render(val.to_s)
        .html_safe
    end
end

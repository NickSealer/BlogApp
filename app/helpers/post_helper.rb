# frozen_string_literal: true

module PostHelper
  def body_preview_text(body)
    "#{body[0..120]}..."
  end
end

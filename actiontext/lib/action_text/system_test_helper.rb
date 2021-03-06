# frozen_string_literal: true

module ActionText
  module SystemTestHelper
    # Locates a Trix editor and fills it in with the given HTML.
    #
    # The editor can be found by:
    # * its +id+
    # * its +placeholder+
    # * its +aria-label+
    # * the +name+ of its input
    #
    # Examples:
    #
    #   # <trix-editor id="message_content" ...></trix-editor>
    #   fill_in_rich_text_area "message_content", with: "Hello <em>world!</em>"
    #
    #   # <trix-editor placeholder="Your message here" ...></trix-editor>
    #   fill_in_rich_text_area "Your message here", with: "Hello <em>world!</em>"
    #
    #   # <trix-editor aria-label="Message content" ...></trix-editor>
    #   fill_in_rich_text_area "Message content", with: "Hello <em>world!</em>"
    #
    #   # <input id="trix_input_1" name="message[content]" type="hidden">
    #   # <trix-editor input="trix_input_1"></trix-editor>
    #   fill_in_rich_text_area "message[content]", with: "Hello <em>world!</em>"
    def fill_in_rich_text_area(locator, with:)
      page.execute_script(<<~JS, find(:rich_text_area, locator).native, with.to_s)
        const [element, html] = arguments;
        element.editor.loadHTML(html);
      JS
    end
  end
end

Capybara.add_selector :rich_text_area do
  label "rich-text area"
  xpath do |locator|
    input_located_by_name = XPath.anywhere(:input).where(XPath.attr(:name) == locator).attr(:id)

    XPath.descendant(:"trix-editor").where \
      XPath.attr(:id).equals(locator) |
      XPath.attr(:placeholder).equals(locator) |
      XPath.attr(:"aria-label").equals(locator) |
      XPath.attr(:input).equals(input_located_by_name)
  end
end

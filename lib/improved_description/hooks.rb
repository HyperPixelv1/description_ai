module ImprovedDescription
  class Hooks < Redmine::Hook::ViewListener
    # Description kısmında markdown satırına buton ekler
    render_on :view_issues_form_details_bottom, partial: "improved_description/button", locals: { position: "toolbar" }
  end
end

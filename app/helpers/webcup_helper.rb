module WebcupHelper

  def bootstrap_alert_class(rails_flash)
    case rails_flash
      when :success
        'alert-success'
      when :notice
      when :info
        'alert-info'
      when :warning
        'alert-warning'
      when :error
        'alert-danger'
      else
        'alert-info'
    end

  end

  def is_active_controller(controller_name)
    params[:controller] == controller_name ? "active" : nil
  end

  def is_active_action(action_name)
    params[:action] == action_name ? "active" : nil
  end

  def tabular_item(title, value, _options = {})

    title = "#{title}:" if title
    content_tag :div, class: 'row' do
      concat content_tag(:div, title, class: 'col-xs-6 title')
      concat content_tag(:div, value, class: 'col-xs-6')
    end

  end

  def menu_item(path, name, options = {})
    li_options = {}
    li_options['class'] = 'active' if current_page?(path)
    content_tag :li, li_options do
      link_to path do
        icon_tag(options[:icon]) +
            content_tag(:span, name, class: 'nav-label')
      end
    end
  end

  def icon_tag(icon, options = {})
    return '' if icon.nil?

    provided_class = options[:class]
    css_class = ['fa', "fa-#{icon}"]
    css_class << provided_class if provided_class


    text = options.fetch(:text, '')
    i_options = {class: css_class}
    if options[:tooltip]
      # classes << 'tooltip'
      i_options[:title] = options[:tooltip]
      i_options[:data] = {toggle: 'tooltip'}
    end


    i_tag = content_tag :i, '', i_options
    (i_tag + text).html_safe
  end

  def btn_link_to(text, path = '#', options = {})

    # <a href="" class="btn btn-primary btn-xs">Create new project</a>
    style = options.delete(:style) { 'primary' }
    size = options.delete(:size) { 'xs' }
    provided_class = options[:class]
    css_class = ['btn']
    css_class << "btn-#{style}"
    css_class << "btn-#{size}"
    css_class << provided_class if provided_class
    options[:class] = css_class

    icon = options.delete(:icon)
    text = "#{icon_tag(icon)} #{text}".html_safe if icon
    link_to text, path, options
  end

  def button_for_modal_help(id, text)
    content_tag :button, text, type: 'button', class: 'btn btn-white btn-lg pull-right', data: {toggle: 'modal', target: "##{id}"}
  end


  def modal_for(selector, options, &block)
    render(
        partial: 'shared/modal',
        locals: options.merge({block: block, selector: selector})
    )
  end

  def modal_help(selector, text, options, &block)
    button_for_modal_help(selector, text) + modal_for(selector, options, &block)
  end

  def todo(text, options = {})
    checked = options[:checked]
    content_tag :li do
      concat check_box_tag('', 'x', checked, class: 'i-checks', disabled: '')
      concat content_tag(:span, text, class: 'm-l-xs')
      concat content_tag(:small, options[:small], class: 'm-l-xs text-info') if options[:small]
      date_params = options[:date]
      concat date_label_for_todo(date_params, checked) if date_params
    end
  end


  def done(text, options = {})
    todo(text, options.merge({checked: true}))
  end

  def date_label_for_todo(date_params, done = false)
    date_str, offset = date_params.split('+')
    date = Date.parse(date_str)
    due_date = date + offset.to_i
    days_left = (due_date - Date.today).to_i
    text = case days_left
             when 0
               ' dnes'
             when 1
               ' zítra'
             when -1
               ' včera'
             else
               " #{days_left} dní"
           end
    color = if days_left < 0
              'danger'
            elsif days_left == 0
              'warning'
            elsif days_left < 7
              'info'
            else
              'primary'
            end
    color = 'plain' if done
    content_tag(:small, class: "label label-#{color}") do
      concat icon_tag('clock-o')
      concat text

    end

  end

end

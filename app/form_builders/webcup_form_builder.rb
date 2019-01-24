class WebcupFormBuilder < ActionView::Helpers::FormBuilder

  TYPE_TEXT = :text
  TYPE_NUMBER = :number
  TYPE_DATE_SELECT = :date_select
  TYPE_TIME_SELECT = :time_select
  TYPE_DATETIME_SELECT = :datetime_select
  TYPE_DATE_FIELD = :date_field
  TYPE_TIME_FIELD = :time_field
  TYPE_DATETIME_FIELD = :datetime_field
  TYPE_EMAIL = :email
  TYPE_TEXTAREA = :textarea
  TYPE_CKEDITOR = :ckeditor
  TYPE_PASSWORD = :password
  TYPE_CHECKBOX = :checkbox
  TYPE_SWITCH = :switch
  TYPE_AWESOME_RADIOS = :awesome_radios
  TYPE_SELECT = :select
  TYPE_CHOSEN = :chosen
  TYPE_SELECT2 = :select2



  def form_group_field(name, options = {}, &block)

=begin
    <%= f.form_group 'Email', type: :email, help: 'Example block-level help text here.', placeholder: 'Email' %>

    <div class="form-group">
      <label class="col-lg-2 control-label">Email</label>

      <div class="col-lg-10">
        <input type="email" placeholder="Email" class="form-control">
        <span class="help-block m-b-none">Example block-level help text here.</span>
      </div>
    </div>
=end

    label_length = options.delete(:label_length) || 2    # label_length is deprecated, use label_width instead
    field_length = options.delete(:field_length) || 10   # field_length is deprecated, use field_width instead
    label_width = options.delete(:label_width) || label_length
    field_width = options.delete(:field_width) || field_length
    label_name = options.delete(:label) || name.to_s.capitalize
    help = options.delete(:help)
    type = options[:type]

    if type == :select
    end


    @template.content_tag :div, class: 'form-group' do
      @template.concat label(name, label_name, class: "col-lg-#{label_width} control-label") if label_width > 0
      # @template.concat @template.content_tag(:label, label, class: "col-lg-#{label_length} control-label")
      @template.concat(@template.content_tag(:div, class: "col-lg-#{field_width}") {
        if block_given?
          content = @template.capture(&block)
          @template.concat content
        else
          @template.concat input_control(name, options)
        end
        @template.concat @template.content_tag(:span, help, class: 'help-block m-b-none') if help
      })
    end
  end

  def switch_field(name, options)
    checked_value = options.delete(:checked_value) || '1'
    unchecked_value = options.delete(:unchecked_value) || '0'
    options[:id] ||= "#{@object_name}_#{name}"
    @template.content_tag :div, class: 'onoffswitch', id: "#{options[:id]}_wrapper" do
      @template.concat check_box(name, options.merge({class: "onoffswitch-checkbox"}), checked_value, unchecked_value)
      @template.concat(@template.content_tag(:label, class: "onoffswitch-label", for: options[:id]) do
        @template.concat(@template.content_tag(:span, '', class: "onoffswitch-inner"))
        @template.concat(@template.content_tag(:span, '', class: "onoffswitch-switch"))
      end
      )
    end
  end

  def awesome_radio_fields(name, options)
    # needs awesome-bootstrap-checkbox.css or custom styling
    values = options.delete(:values)
    color = options.delete(:color) || 'info'
    values.map do |title, value|
      @template.content_tag(:div, class: "radio radio-#{color} radio-inline") do
        @template.concat radio_button(name, value)
        @template.concat label(name, title, value: value)
      end
    end.join.html_safe
  end


  def input_control(name, options)
    type = options[:type]
    if options[:pre] || options[:post] || type == :date
      @template.content_tag :div, class: 'input-group' do
        pre_part(options) + input_field(name, options) + post_part(options)
      end
    else
      input_field(name, options)
    end
  end

  def pre_part(options)
    type = options[:type]
    pre = options.delete(:pre)
    if pre || type == :date
      @template.content_tag :span, class: 'input-group-addon' do
        case type
          when :date
            @template.icon_tag 'calendar'
          else
            pre
        end
      end
    else
      ''.html_safe
    end

  end

  def post_part(options)
    post = options.delete(:post)

    if post
      @template.content_tag :span, class: 'input-group-addon' do
        post
      end
    else
      ''.html_safe
    end
  end


  def input_field(name, options)
    options[:class] = *options[:class]
    options[:class] << 'form-control'
    type = options.delete(:type)

    case type
      when :text, nil
        text_field(name, options)
      when :number
        number_field(name, options)
      when :date_select
        date_select(name, options)
      when :time_select
        time_select(name, options)
      when :datetime_select
        datetime_select(name, options)
      when :date_field
        date_field(name, options)
      when :time_field
        time_field(name, options)
      when :datetime_field
        datetime_field(name, options)
      when :email
        email_field(name, options)
      when :textarea
        text_area(name, options)
      when :ckeditor
        cktext_area(name, options)
      when :password
        password_field(name, options)
      when :checkbox
        options[:class] << 'i-checks'
        check_box(name, options)
      when :switch
        switch_field(name, options)
      when :awesome_radios
        awesome_radio_fields(name, options)
      when :select
        collection = options.delete(:collection) or raise 'Please specify collection for select.'
        select name, collection, options, {class: options[:class]}.merge(options[:html_options] || {})
      when :chosen
        options[:class] << 'chosen-select'
        collection = options.delete(:collection) or raise 'Please specify collection for chosen.'
        select name, collection, options, {class: options[:class]}.merge(options[:html_options] || {})
      when :select2
        options[:class] << 'select2-select'
        collection = options.delete(:collection) or raise 'Please specify collection for select2.'
        select name, collection, options, {class: options[:class]}.merge(options[:html_options] || {})
      else
        raise "Unknown input field type '#{type}'"
    end
  end

end


=begin
<select data-placeholder="Choose a Country..." class="chosen-select" style="width:350px;" tabindex="2">
<option value="">Select</option>
<option value="United States">United States</option>
<option value="United Kingdom">United Kingdom</option>
<option value="Yemen">Yemen</option>
<option value="Zambia">Zambia</option>
<option value="Zimbabwe">Zimbabwe</option>
</select>
=end

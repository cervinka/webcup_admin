class WebcupFormBuilder < ActionView::Helpers::FormBuilder
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

    label_length = options.delete(:label_length) || 2
    field_length = options.delete(:field_length) || 10
    label_name = options.delete(:label) || name.to_s.capitalize
    help = options.delete(:help)
    type = options[:type]

    if type == :select
    end


    @template.content_tag :div, class: 'form-group' do
      @template.concat label(name, label_name, class: "col-lg-#{label_length} control-label")
      # @template.concat @template.content_tag(:label, label, class: "col-lg-#{label_length} control-label")
      @template.concat(@template.content_tag(:div, class: "col-lg-#{field_length}") {
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
      when :text, :date, :datetime, nil
        text_field(name, options)
      when :number
        number_field(name, options)
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

module Ubiquo
  module Helpers
    module CoreUbiquoHelpers

      # Adds the default stylesheet tags needed for ubiquo
      def ubiquo_stylesheet_link_tags(files=['ubiquo','ubiquo_application','lightwindow'])
        files.delete 'lightwindow' unless File.exists?(Rails.root.join('public', 'stylesheets', 'lightwindow.css'))
        files.collect do |css|
          stylesheet_link_tag "#{css}", :media => "all"
        end.join "\n"
      end

      # return javascripts with ubiquo path.
      def ubiquo_javascript_include_tags(files=['ubiquo', 'lightwindow'])
         files.delete 'lightwindow' unless File.exists?(Rails.root.join('public', 'javascripts', 'ubiquo', 'lightwindow.js'))
        files.collect do |js|
          javascript_include_tag "ubiquo/#{js}"
        end.join "\n"
      end

      # surrounds the block between the specified box.
      def box(name, options={}, &block)
        options.merge!(:body=>capture(&block))
        concat(render(:partial => "shared/ubiquo/boxes/#{name}", :locals => options), block.binding)
      end

      # return HTML code for required ubiquo image
      def ubiquo_image_tag(name, options={})
        options[:src] ||= ubiquo_image_path(name)
        options[:alt] ||= "Ubiquo image"
        tag('img', options)
      end

      # return path for required ubiquo image
      def ubiquo_image_path(name)
        "/images/ubiquo/#{name}"
      end

      def ubiquo_boolean_image(value)
        ubiquo_image_tag(value ? 'ok.gif' : 'ko.gif')
      end

      # Return true if string_date is a valid date representation with a
      # given format (the so-called italian format by default: %d/%m/%Y)
      def is_valid_date?(string_date, format="%d/%m/%Y")
        begin
          time = Date.strptime(string_date, format)
        rescue ArgumentError
          return false
        end
        true
      end

      # Include calendar_date_select javascript and stylesheets
      # with a default theme, basedir and locale
      def calendar_includes(options = {})
        iso639_locale = options[:locale] || I18n.locale.to_s
        CalendarDateSelect.format = options[:format] || :italian
        calendar_date_select_includes "ubiquo", :locale => iso639_locale
      end

      # Renders a message in a help block in the sidebar
      def help_block_sidebar(message)
        render :partial => '/shared/ubiquo/help_block_sidebar',
        :locals => {:message => message}
      end

      # Renders a preview
      # A preview is usually used to show the values of an instance somewhere,
      # in an unobtrusive way
      # The instance to preview is taken from params[:preview_id]
      def show_preview(model_class, options = {}, &block)
        return unless params[:preview_id]
        previewed = model_class.find(params[:preview_id], options)
        return unless previewed
        locals = {:body=>capture(previewed, &block)}
        concat(render(:partial => "shared/ubiquo/preview_box", :locals => locals))
      end
    end
  end
end

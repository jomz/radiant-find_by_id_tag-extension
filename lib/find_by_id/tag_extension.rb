module FindById::TagExtension
  include Radiant::Taggable
  
  
    desc %{
      Inside this tag all page related tags refer to the page found at the @path@ attribute.
      @path@s may be relative or absolute paths.
      If an @id@ attribute is passed, the path attribute will be ignored
      *Usage:*

      <pre><code><r:find path="value_to_find">...</r:find></code></pre>
    }
    tag 'find' do |tag|
      required_attr(tag,'path','url','id')

      if id = tag.attr.delete('id')
        found = Page.find(id.to_i)
      else
        path = tag.attr['path'] || tag.attr['url']
        found = Page.find_by_path(absolute_path_for(tag.locals.page.path, path))
      end
      if page_found?(found)
        tag.locals.page = found
        tag.expand
      end
    end

end
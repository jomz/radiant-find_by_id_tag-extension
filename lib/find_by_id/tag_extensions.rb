module FindById::TagExtensions
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

  desc %{
    Aggregates the children of multiple paths using the @paths@ or @ids@ attribute.
    Useful for combining many different sections/categories into a single
    feed or listing.
    
    *Usage*:
    
    <pre><code><r:aggregate paths="/section1; /section2; /section3"> ... </r:aggregate>
    <r:aggregate ids="4; 6; 7"> ... </r:aggregate></code></pre>
  }
  tag "aggregate" do |tag|
    required_attr(tag, 'paths', 'urls', 'ids')
    if ids = tag.attr.delete('ids')
      tag.locals.parent_ids = ids.split(';').map(&:strip).reject(&:blank?)
    else
      paths = (tag.attr['paths']||tag.attr["urls"]).split(";").map(&:strip).reject(&:blank?).map { |u| clean_path u }
      parent_ids = paths.map {|u| Page.find_by_path(u) }.map(&:id)
      tag.locals.parent_ids = parent_ids
    end
    tag.expand
  end
  

end
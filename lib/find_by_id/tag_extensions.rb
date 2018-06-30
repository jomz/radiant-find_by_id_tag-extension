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

  desc %{
    Sets the scope to the individual aggregated page allowing you to
    iterate through each of the listed paths.

    *Usage*:

    <pre><code><r:aggregate:each paths="/section1; /section2; /section3"> ... </r:aggregate:each></code></pre>
  }
  tag "aggregate:each" do |tag|
    aggregates = []
    # tag.locals.aggregated_pages = tag.locals.parent_ids.map {|p| Page.find(p)}
    # Make this tag accept 'order' params. Ideally this would go in Radiant's standard_tags.rb
    order = children_find_options(tag).delete(:order)
    # if no order param was set, keep the order in which the ids were given
    if tag.attr['order'].nil?
      tag.locals.aggregated_pages = tag.locals.parent_ids.map{|pid| Page.find pid}
    else
      tag.locals.aggregated_pages = Page.find(tag.locals.parent_ids, :order => order)
    end
    tag.locals.aggregated_pages.each do |aggregate_page|
      tag.locals.page = aggregate_page
      aggregates << tag.expand
    end
    aggregates.flatten.join('')
  end

  desc "Renders the id of the current page"
  tag "id" do |tag|
    tag.locals.page.id
  end

end
